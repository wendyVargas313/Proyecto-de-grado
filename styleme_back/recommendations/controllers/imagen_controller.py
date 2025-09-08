from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from recommendations.ia.detector import detect_clothing_items
from recommendations.entity.user import Usuario
from recommendations.entity.clothing import Prenda
import os
import json

@csrf_exempt
def detect_clothing_view(request):
    """
    Vista que recibe una imagen y un correo. Detecta prendas con YOLO y guarda en el guardarropa del usuario.
    """

    if request.method == 'POST':
        image = request.FILES.get('image')
        email = request.POST.get('email')  # Asegúrate que el frontend envíe el email como form-data

        if not image or not email:
            return JsonResponse({'error': 'Faltan datos: imagen o email'}, status=400)

        # Buscar el usuario en la base de datos
        user = Usuario.objects(correo=email).first()
        if not user:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)

        # Guardar imagen
        os.makedirs('recommendations/media', exist_ok=True)
        image_path = os.path.join('recommendations', 'media', image.name)
        with open(image_path, 'wb+') as destination:
            for chunk in image.chunks():
                destination.write(chunk)

        try:
            # Detectar prendas con YOLO
            detections = detect_clothing_items(image_path)

            nuevas_prendas = []
            for det in detections:
                prenda = Prenda(
                    tipo=det['tipo'],
                    color="desconocido",     # puedes mejorarlo más adelante
                    temporada="desconocido"  # idem
                )
                nuevas_prendas.append(prenda)

            # Guardar en el guardarropa del usuario
            user.guardarropa.extend(nuevas_prendas)
            user.save()

            return JsonResponse({
                'message': 'Prendas detectadas y guardadas',
                'prendas': [p.to_mongo().to_dict() for p in nuevas_prendas]
            })

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Método no permitido'}, status=405)