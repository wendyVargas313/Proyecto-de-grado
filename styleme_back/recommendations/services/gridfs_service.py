from pymongo import MongoClient
from gridfs import GridFS
from bson import ObjectId
from django.conf import settings
import os
from typing import Optional, BinaryIO
from datetime import datetime


class GridFSService:
    """Servicio para gestionar almacenamiento de imágenes en MongoDB GridFS"""
    
    _fs = None
    _db = None

    @classmethod
    def initialize(cls):
        """Inicializa conexión a GridFS"""
        if cls._fs is not None:
            return

        try:
            # Obtener configuración de MongoDB desde settings
            mongo_host = getattr(settings, 'MONGO_HOST', 'localhost')
            mongo_port = getattr(settings, 'MONGO_PORT', 27017)
            mongo_db = getattr(settings, 'MONGO_DB', 'styleme_db')
            
            # Conectar a MongoDB
            client = MongoClient(mongo_host, mongo_port)
            cls._db = client[mongo_db]
            
            # Inicializar GridFS
            cls._fs = GridFS(cls._db)
            
            print("✅ GridFS inicializado correctamente")

        except Exception as e:
            print(f"❌ Error al inicializar GridFS: {str(e)}")
            raise

    @classmethod
    def get_fs(cls):
        """Obtiene la instancia de GridFS"""
        if cls._fs is None:
            cls.initialize()
        return cls._fs

    @staticmethod
    def upload_image(file_data, file_name: str, user_email: str, content_type: str = 'image/jpeg') -> str:
        """
        Sube una imagen a MongoDB GridFS
        
        Args:
            file_data: Datos del archivo (file object o bytes)
            file_name: Nombre del archivo
            user_email: Email del usuario (para metadata)
            content_type: Tipo MIME del archivo
            
        Returns:
            ID del archivo en GridFS (string)
            
        Raises:
            Exception: Si hay error al subir la imagen
        """
        try:
            fs = GridFSService.get_fs()
            
            # Leer datos del archivo
            if hasattr(file_data, 'read'):
                file_content = file_data.read()
                if hasattr(file_data, 'seek'):
                    file_data.seek(0)  # Resetear puntero
            else:
                file_content = file_data

            # Metadata del archivo
            metadata = {
                'user_email': user_email,
                'original_filename': file_name,
                'content_type': content_type,
                'upload_date': datetime.utcnow(),
                'folder': 'wardrobe'
            }

            # Guardar en GridFS
            file_id = fs.put(
                file_content,
                filename=file_name,
                content_type=content_type,
                metadata=metadata
            )

            return str(file_id)

        except Exception as e:
            raise Exception(f"Error al subir imagen a GridFS: {str(e)}")

    @staticmethod
    def get_image(file_id: str) -> Optional[bytes]:
        """
        Obtiene una imagen de GridFS
        
        Args:
            file_id: ID del archivo en GridFS
            
        Returns:
            Bytes de la imagen o None si no existe
        """
        try:
            fs = GridFSService.get_fs()
            
            # Convertir string a ObjectId
            object_id = ObjectId(file_id)
            
            # Obtener archivo
            if fs.exists(object_id):
                grid_out = fs.get(object_id)
                return grid_out.read()
            
            return None

        except Exception as e:
            print(f"Error al obtener imagen: {str(e)}")
            return None

    @staticmethod
    def delete_image(file_id: str) -> bool:
        """
        Elimina una imagen de GridFS
        
        Args:
            file_id: ID del archivo a eliminar
            
        Returns:
            True si se eliminó correctamente
        """
        try:
            fs = GridFSService.get_fs()
            
            # Convertir string a ObjectId
            object_id = ObjectId(file_id)
            
            # Eliminar archivo
            if fs.exists(object_id):
                fs.delete(object_id)
                return True
            
            return False

        except Exception as e:
            print(f"Error al eliminar imagen: {str(e)}")
            return False

    @staticmethod
    def get_image_url(file_id: str) -> str:
        """
        Genera una URL para acceder a la imagen
        
        Args:
            file_id: ID del archivo en GridFS
            
        Returns:
            URL relativa para acceder a la imagen
        """
        # URL del endpoint que servirá la imagen
        return f"/api/images/{file_id}"

    @staticmethod
    def get_image_metadata(file_id: str) -> Optional[dict]:
        """
        Obtiene metadata de una imagen
        
        Args:
            file_id: ID del archivo
            
        Returns:
            Diccionario con metadata o None
        """
        try:
            fs = GridFSService.get_fs()
            object_id = ObjectId(file_id)
            
            if fs.exists(object_id):
                grid_out = fs.get(object_id)
                return {
                    'filename': grid_out.filename,
                    'content_type': grid_out.content_type,
                    'length': grid_out.length,
                    'upload_date': grid_out.upload_date,
                    'metadata': grid_out.metadata
                }
            
            return None

        except Exception as e:
            print(f"Error al obtener metadata: {str(e)}")
            return None

    @staticmethod
    def list_user_images(user_email: str) -> list:
        """
        Lista todas las imágenes de un usuario
        
        Args:
            user_email: Email del usuario
            
        Returns:
            Lista de diccionarios con info de imágenes
        """
        try:
            fs = GridFSService.get_fs()
            
            # Buscar archivos del usuario
            files = fs.find({'metadata.user_email': user_email})
            
            result = []
            for file in files:
                result.append({
                    'file_id': str(file._id),
                    'filename': file.filename,
                    'content_type': file.content_type,
                    'upload_date': file.upload_date,
                    'url': GridFSService.get_image_url(str(file._id))
                })
            
            return result

        except Exception as e:
            print(f"Error al listar imágenes: {str(e)}")
            return []
