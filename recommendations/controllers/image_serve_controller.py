from django.http import HttpResponse, JsonResponse
from recommendations.services.gridfs_service import GridFSService
import logging

# Configurar logger
logger = logging.getLogger(__name__)

# Instancia del servicio
gridfs_service = GridFSService()


def serve_image(request, file_id):
    """
    Endpoint para servir imágenes desde MongoDB GridFS
    
    Args:
        request: HTTP request
        file_id: ID del archivo en GridFS
        
    Returns:
        HttpResponse con la imagen o error 404
    """
    try:
        # Obtener imagen de GridFS
        image_data = gridfs_service.get_image(file_id)
        
        if image_data is None:
            return JsonResponse({
                'success': False,
                'error': 'Imagen no encontrada',
                'error_type': 'IMAGE_NOT_FOUND'
            }, status=404)
        
        # Obtener metadata para content_type
        metadata = gridfs_service.get_image_metadata(file_id)
        content_type = metadata.get('content_type', 'image/jpeg') if metadata else 'image/jpeg'
        
        # Retornar imagen
        response = HttpResponse(image_data, content_type=content_type)
        response['Content-Disposition'] = f'inline; filename="{file_id}"'
        
        return response
        
    except Exception as e:
        logger.error(f"Error al servir imagen {file_id}: {str(e)}")
        return JsonResponse({
            'success': False,
            'error': 'Error al obtener la imagen',
            'error_type': 'INTERNAL_SERVER_ERROR'
        }, status=500)


def get_image_metadata_view(request, file_id):
    """
    Endpoint para obtener metadata de una imagen
    
    Args:
        request: HTTP request
        file_id: ID del archivo en GridFS
        
    Returns:
        JsonResponse con metadata o error 404
    """
    try:
        metadata = gridfs_service.get_image_metadata(file_id)
        
        if metadata is None:
            return JsonResponse({
                'success': False,
                'error': 'Imagen no encontrada',
                'error_type': 'IMAGE_NOT_FOUND'
            }, status=404)
        
        # Convertir datetime a string para JSON
        if 'upload_date' in metadata:
            metadata['upload_date'] = metadata['upload_date'].isoformat()
        
        return JsonResponse({
            'success': True,
            'metadata': metadata
        }, status=200)
        
    except Exception as e:
        logger.error(f"Error al obtener metadata de imagen {file_id}: {str(e)}")
        return JsonResponse({
            'success': False,
            'error': 'Error al obtener metadata',
            'error_type': 'INTERNAL_SERVER_ERROR'
        }, status=500)
