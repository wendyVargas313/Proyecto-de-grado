from recommendations.repository.user_repository import UserRepository
from recommendations.ia.detector import detect_clothing_items
from recommendations.entity.clothing import Prenda
from recommendations.dto.clothing_dto import ClothingDTO, ClothingDetectionDTO
from typing import List
import os


class ImagenService:
    """Servicio para lógica de negocio relacionada con detección de imágenes"""

    def __init__(self):
        self.user_repository = UserRepository()
        self.media_path = 'recommendations/media'

    def detect_and_save_clothing(self, email: str, image_file, image_name: str) -> List[ClothingDTO]:
        """
        Detecta prendas en una imagen y las guarda en el guardarropa del usuario
        
        Args:
            email: Correo del usuario
            image_file: Archivo de imagen
            image_name: Nombre del archivo de imagen
            
        Returns:
            Lista de ClothingDTOs detectados
            
        Raises:
            ValueError: Si el usuario no existe o hay error en la detección
        """
        # Buscar usuario
        user = self.user_repository.find_by_email(email)
        if not user:
            raise ValueError("Usuario no encontrado")

        # Guardar imagen temporalmente
        image_path = self._save_image(image_file, image_name)

        try:
            # Detectar prendas con YOLO
            detections = detect_clothing_items(image_path)

            if not detections:
                raise ValueError("No se detectaron prendas en la imagen")

            # Convertir detecciones a entidades Prenda
            nuevas_prendas = []
            for det in detections:
                prenda = Prenda(
                    tipo=det.get('tipo', det.get('type', 'desconocido')),
                    color="desconocido",  # Puede mejorarse con análisis de color
                    temporada="desconocido"  # Puede mejorarse con clasificación adicional
                )
                nuevas_prendas.append(prenda)

            # Guardar prendas en el guardarropa del usuario
            self.user_repository.add_clothing_to_wardrobe(user, nuevas_prendas)

            # Convertir a DTOs
            clothing_dtos = [ClothingDTO.from_entity(prenda) for prenda in nuevas_prendas]

            return clothing_dtos

        except Exception as e:
            raise ValueError(f"Error al detectar prendas: {str(e)}")

    def _save_image(self, image_file, image_name: str) -> str:
        """
        Guarda una imagen en el sistema de archivos
        
        Args:
            image_file: Archivo de imagen
            image_name: Nombre del archivo
            
        Returns:
            Ruta donde se guardó la imagen
        """
        # Crear directorio si no existe
        os.makedirs(self.media_path, exist_ok=True)

        # Ruta completa del archivo
        image_path = os.path.join(self.media_path, image_name)

        # Guardar imagen
        with open(image_path, 'wb+') as destination:
            for chunk in image_file.chunks():
                destination.write(chunk)

        return image_path

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

    def validate_image(self, image_file) -> bool:
        """
        Valida que el archivo sea una imagen válida
        
        Args:
            image_file: Archivo a validar
            
        Returns:
            True si es válido
        """
        if not image_file:
            return False

        # Validar extensión
        valid_extensions = ['.jpg', '.jpeg', '.png', '.bmp', '.webp']
        file_extension = os.path.splitext(image_file.name)[1].lower()

        return file_extension in valid_extensions
