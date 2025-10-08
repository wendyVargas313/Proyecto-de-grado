from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from recommendations.services.imagen_service import ImagenService


# Instancia del servicio
imagen_service = ImagenService()


@csrf_exempt
def detect_clothing_view(request):
    """
    Vista que recibe una imagen y un correo. Detecta prendas con YOLO y guarda en el guardarropa del usuario.
    """
    if request.method == 'POST':
        try:
            # Obtener datos de la solicitud
            image = request.FILES.get('image')
            email = request.POST.get('email')

            # Validación básica
            if not image or not email:
                return JsonResponse({'error': 'Faltan datos: imagen o email'}, status=400)

            # Validar que sea una imagen válida
            if not imagen_service.validate_image(image):
                return JsonResponse({'error': 'Formato de imagen no válido'}, status=400)

            # Llamar al servicio para detectar y guardar prendas
            prendas_detectadas = imagen_service.detect_and_save_clothing(
                email=email,
                image_file=image,
                image_name=image.name
            )

            # Construir respuesta
            return JsonResponse({
                'message': 'Prendas detectadas y guardadas exitosamente',
                'cantidad': len(prendas_detectadas),
                'prendas': [prenda.to_dict() for prenda in prendas_detectadas]
            }, status=200)

        except ValueError as e:
            return JsonResponse({'error': str(e)}, status=400)
        except Exception as e:
            return JsonResponse({'error': f'Error interno: {str(e)}'}, status=500)

    return JsonResponse({'error': 'Método no permitido'}, status=405)