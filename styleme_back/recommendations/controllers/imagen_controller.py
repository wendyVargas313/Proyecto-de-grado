from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from recommendations.services.imagen_service import ImagenService
import logging

# Configurar logger
logger = logging.getLogger(__name__)

# Instancia del servicio
imagen_service = ImagenService()


@csrf_exempt
def detect_clothing_view(request):
    """
    Vista que recibe una o varias imágenes y un correo.
    Detecta prendas con YOLO, las sube a Firebase Storage y guarda en el guardarropa del usuario.
    
    Criterios de aceptación:
    - Solo acepta imágenes JPG o PNG
    - Máximo 2 MB por imagen
    - Almacena en Firebase Storage
    - Guarda URL en MongoDB
    - Notifica éxito o error claramente
    """
    if request.method == 'POST':
        try:
            # Obtener datos de la solicitud
            email = request.POST.get('email')
            
            # Validación de email
            if not email:
                return JsonResponse({
                    'success': False,
                    'error': 'Email es requerido',
                    'error_type': 'MISSING_EMAIL'
                }, status=400)

            # Obtener imágenes (puede ser una o múltiples)
            images = request.FILES.getlist('images') or [request.FILES.get('image')]
            images = [img for img in images if img is not None]

            if not images:
                return JsonResponse({
                    'success': False,
                    'error': 'No se proporcionó ninguna imagen',
                    'error_type': 'MISSING_IMAGE'
                }, status=400)

            # Procesar cada imagen
            all_prendas = []
            processed_images = 0
            errors = []

            for idx, image in enumerate(images):
                try:
                    # Llamar al servicio para detectar y guardar prendas
                    prendas_detectadas, success_message = imagen_service.detect_and_save_clothing(
                        email=email,
                        image_file=image,
                        image_name=image.name
                    )
                    
                    all_prendas.extend(prendas_detectadas)
                    processed_images += 1
                    
                    logger.info(f"Imagen {idx + 1}/{len(images)} procesada: {success_message}")

                except ValueError as e:
                    error_msg = str(e)
                    errors.append({
                        'image': image.name,
                        'error': error_msg
                    })
                    logger.warning(f"Error procesando imagen {image.name}: {error_msg}")

            # Construir respuesta
            if processed_images == 0:
                # Ninguna imagen se procesó correctamente
                return JsonResponse({
                    'success': False,
                    'error': 'No se pudo procesar ninguna imagen',
                    'error_type': 'PROCESSING_FAILED',
                    'details': errors
                }, status=400)

            # Al menos una imagen se procesó correctamente
            response_data = {
                'success': True,
                'message': f'✅ Carga completada exitosamente. Se procesaron {processed_images} de {len(images)} imagen(es)',
                'total_images': len(images),
                'processed_images': processed_images,
                'total_prendas_detectadas': len(all_prendas),
                'prendas': [prenda.to_dict() for prenda in all_prendas]
            }

            # Agregar advertencias si hubo errores parciales
            if errors:
                response_data['warnings'] = errors
                response_data['message'] += f'. {len(errors)} imagen(es) no se pudieron procesar'

            return JsonResponse(response_data, status=200)

        except ValueError as e:
            # Errores de validación o lógica de negocio
            error_message = str(e)
            logger.error(f"Error de validación: {error_message}")
            
            # Determinar tipo de error
            error_type = 'VALIDATION_ERROR'
            if 'formato' in error_message.lower() or 'jpg' in error_message.lower() or 'png' in error_message.lower():
                error_type = 'INVALID_FORMAT'
            elif 'tamaño' in error_message.lower() or 'mb' in error_message.lower():
                error_type = 'FILE_TOO_LARGE'
            elif 'usuario no encontrado' in error_message.lower():
                error_type = 'USER_NOT_FOUND'
            elif 'firebase' in error_message.lower():
                error_type = 'STORAGE_ERROR'
            
            return JsonResponse({
                'success': False,
                'error': error_message,
                'error_type': error_type
            }, status=400)

        except Exception as e:
            # Errores inesperados del servidor
            error_message = str(e)
            logger.error(f"Error interno del servidor: {error_message}", exc_info=True)
            
            return JsonResponse({
                'success': False,
                'error': 'Error interno del servidor. Por favor, intenta nuevamente.',
                'error_type': 'INTERNAL_SERVER_ERROR',
                'details': error_message if logger.level == logging.DEBUG else None
            }, status=500)

    return JsonResponse({
        'success': False,
        'error': 'Método no permitido. Use POST',
        'error_type': 'METHOD_NOT_ALLOWED'
    }, status=405)