from recommendations.repository.user_repository import UserRepository
from recommendations.ia.detector import detect_clothing_items
from recommendations.entity.clothing import Prenda
from recommendations.dto.clothing_dto import ClothingDTO, ClothingDetectionDTO, ImageUploadValidationDTO
from recommendations.services.gridfs_service import GridFSService
from typing import List, Tuple
import os
import uuid
from datetime import datetime


class ImagenService:
    """Servicio para lógica de negocio relacionada con detección de imágenes"""

    # Constantes de validación según criterios de aceptación
    MAX_FILE_SIZE_MB = 10
    MAX_FILE_SIZE_BYTES = MAX_FILE_SIZE_MB * 1024 * 1024  # 10 MB en bytes
    ALLOWED_FORMATS = ['jpg', 'jpeg', 'png', 'webp']
    ALLOWED_MIME_TYPES = ['image/jpeg', 'image/png', 'image/webp']

    def __init__(self):
        self.user_repository = UserRepository()
        self.gridfs_service = GridFSService()
        self.temp_media_path = 'recommendations/media/temp'

    def detect_and_save_clothing(self, email: str, image_file, image_name: str) -> Tuple[List[ClothingDTO], str]:
        """
        Detecta prendas en una imagen y las guarda en el guardarropa del usuario
        
        Args:
            email: Correo del usuario
            image_file: Archivo de imagen
            image_name: Nombre del archivo de imagen
            
        Returns:
            Tupla con (Lista de ClothingDTOs detectados, mensaje de éxito)
            
        Raises:
            ValueError: Si el usuario no existe o hay error en la detección
        """
        # 1. Validar imagen según criterios de aceptación
        validation = self.validate_image_upload(image_file)
        if not validation.is_valid:
            raise ValueError(validation.error_message)

        # 2. Buscar usuario
        user = self.user_repository.find_by_email(email)
        if not user:
            raise ValueError("Usuario no encontrado")

        # 3. Generar nombre único para la imagen
        file_extension = os.path.splitext(image_name)[1].lower()
        unique_filename = f"{email}_{uuid.uuid4()}{file_extension}"

        # 4. Guardar imagen temporalmente para detección
        temp_image_path = self._save_temp_image(image_file, unique_filename)

        try:
            # 5. Detectar prendas con YOLO
            detections = detect_clothing_items(temp_image_path)

            if not detections:
                # Limpiar archivo temporal
                self._cleanup_temp_file(temp_image_path)
                raise ValueError("No se detectaron prendas en la imagen. Por favor, intenta con otra imagen.")

            # 6. Subir imagen a MongoDB GridFS
            try:
                # Resetear el puntero del archivo
                image_file.seek(0)
                
                # Obtener content_type
                content_type = getattr(image_file, 'content_type', 'image/jpeg')
                
                # Subir a GridFS
                file_id = self.gridfs_service.upload_image(
                    image_file, 
                    unique_filename,
                    user_email=email,
                    content_type=content_type
                )
                
                # Generar URL para acceder a la imagen
                image_url = self.gridfs_service.get_image_url(file_id)
                
            except Exception as e:
                self._cleanup_temp_file(temp_image_path)
                raise ValueError(f"Error al subir imagen a MongoDB: {str(e)}")

            # 7. Convertir detecciones a entidades Prenda con ID y URL de imagen
            nuevas_prendas = []
            for det in detections:
                prenda = Prenda(
                    tipo=det.get('tipo', det.get('type', 'desconocido')),
                    color="desconocido",  # TODO: Implementar detección de color
                    temporada="desconocido",  # TODO: Implementar clasificación de temporada
                    imagen_id=file_id,  # ID en GridFS
                    imagen_url=image_url,  # URL para acceder
                    fecha_agregada=datetime.utcnow(),
                    confianza=f"{det.get('confidence', 0.0):.2f}"
                )
                nuevas_prendas.append(prenda)

            # 8. Guardar prendas en el guardarropa del usuario
            self.user_repository.add_clothing_to_wardrobe(user, nuevas_prendas)

            # 9. Limpiar archivo temporal
            self._cleanup_temp_file(temp_image_path)

            # 10. Convertir a DTOs
            clothing_dtos = [ClothingDTO.from_entity(prenda) for prenda in nuevas_prendas]

            success_message = f"✅ Se detectaron y guardaron {len(nuevas_prendas)} prenda(s) exitosamente"
            return clothing_dtos, success_message

        except ValueError as e:
            # Limpiar archivo temporal en caso de error
            self._cleanup_temp_file(temp_image_path)
            raise e
        except Exception as e:
            # Limpiar archivo temporal en caso de error
            self._cleanup_temp_file(temp_image_path)
            raise ValueError(f"Error al procesar la imagen: {str(e)}")

    def validate_image_upload(self, image_file) -> ImageUploadValidationDTO:
        """
        Valida que el archivo cumpla con los criterios de aceptación:
        - Solo JPG o PNG
        - Máximo 2 MB
        
        Args:
            image_file: Archivo a validar
            
        Returns:
            ImageUploadValidationDTO con resultado de validación
        """
        if not image_file:
            return ImageUploadValidationDTO(
                is_valid=False,
                error_message="No se proporcionó ninguna imagen"
            )

        # Obtener información del archivo
        file_name = image_file.name
        file_size = image_file.size
        file_size_mb = file_size / (1024 * 1024)

        # Validar extensión del archivo
        file_extension = os.path.splitext(file_name)[1].lower().replace('.', '')
        if file_extension not in self.ALLOWED_FORMATS:
            return ImageUploadValidationDTO(
                is_valid=False,
                error_message=f"Formato no válido. Solo se aceptan imágenes JPG o PNG. Formato recibido: {file_extension.upper()}",
                file_size_mb=file_size_mb,
                file_format=file_extension
            )

        # Validar tipo MIME
        content_type = getattr(image_file, 'content_type', None)
        if content_type and content_type not in self.ALLOWED_MIME_TYPES:
            return ImageUploadValidationDTO(
                is_valid=False,
                error_message=f"Tipo de archivo no válido. Solo se aceptan imágenes JPG o PNG.",
                file_size_mb=file_size_mb,
                file_format=file_extension
            )

        # Validar tamaño del archivo (máximo 2 MB)
        if file_size > self.MAX_FILE_SIZE_BYTES:
            return ImageUploadValidationDTO(
                is_valid=False,
                error_message=f"La imagen excede el tamaño máximo permitido de {self.MAX_FILE_SIZE_MB} MB. Tamaño actual: {file_size_mb:.2f} MB",
                file_size_mb=file_size_mb,
                file_format=file_extension
            )

        # Validación exitosa
        return ImageUploadValidationDTO(
            is_valid=True,
            error_message=None,
            file_size_mb=file_size_mb,
            file_format=file_extension
        )

    def _save_temp_image(self, image_file, image_name: str) -> str:
        """
        Guarda una imagen temporalmente para procesamiento
        
        Args:
            image_file: Archivo de imagen
            image_name: Nombre del archivo
            
        Returns:
            Ruta donde se guardó la imagen temporal
        """
        # Crear directorio temporal si no existe
        os.makedirs(self.temp_media_path, exist_ok=True)

        # Ruta completa del archivo temporal
        temp_image_path = os.path.join(self.temp_media_path, image_name)

        # Guardar imagen temporalmente
        with open(temp_image_path, 'wb+') as destination:
            for chunk in image_file.chunks():
                destination.write(chunk)

        return temp_image_path

    def _cleanup_temp_file(self, file_path: str):
        """
        Elimina un archivo temporal
        
        Args:
            file_path: Ruta del archivo a eliminar
        """
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
        except Exception as e:
            print(f"⚠️ No se pudo eliminar archivo temporal {file_path}: {str(e)}")

    def get_detections_info(self, detections: List[dict]) -> List[ClothingDetectionDTO]:
        """
        Convierte detecciones brutas a DTOs
        
        Args:
            detections: Lista de detecciones del modelo YOLO
            
        Returns:
            Lista de ClothingDetectionDTOs
        """
        detection_dtos = []
        for det in detections:
            dto = ClothingDetectionDTO(
                tipo=det.get('tipo', det.get('type', 'desconocido')),
                confidence=det.get('confidence', 0.0),
                bounding_box=det.get('bounding_box', [])
            )
            detection_dtos.append(dto)

        return detection_dtos

    def delete_clothing_image(self, file_id: str) -> bool:
        """
        Elimina una imagen de prenda de MongoDB GridFS
        
        Args:
            file_id: ID del archivo en GridFS
            
        Returns:
            True si se eliminó correctamente
        """
        try:
            return self.gridfs_service.delete_image(file_id)
        except Exception as e:
            print(f"Error al eliminar imagen: {str(e)}")
            return False
