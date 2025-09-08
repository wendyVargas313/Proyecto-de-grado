from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from recommendations.entity.user import Usuario
from recommendations.ia.recommender import generate_outfits, predict_outfit_group
import json

# Endpoint que genera outfits basados en las prendas del usuario y sus preferencias
@api_view(['POST'])
def recommend_outfit(request):
    # Extraemos el email del body de la solicitud
    email = request.data.get("email")

    # Validamos que el email haya sido enviado
    if not email:
        return Response({"error": "Email requerido"}, status=400)

    # Buscamos el usuario en la base de datos por correo
    user = Usuario.objects(correo=email).first()
    if not user:
        return Response({"error": "Usuario no encontrado"}, status=404)

    # Generamos los outfits con base en el guardarropa y las preferencias del usuario
    outfits = generate_outfits(user.guardarropa, {
        "color": user.preferencias_color,
        "tipo": user.preferencias_tipo,
        "temporada": user.preferencias_temporada,
    })

    # Guardamos los outfits generados en el perfil del usuario
    user.outfits_generados = outfits
    user.save()

    # Construimos y devolvemos la respuesta con los outfits
    return Response({
        "outfits": [
            {
                "name": o.nombre,
                "items": [  # Cada prenda del outfit
                    {"type": p.tipo, "color": p.color, "season": p.temporada}
                    for p in o.prendas
                ]
            }
            for o in outfits
        ]
    })

# Endpoint que utiliza el modelo IA (KMeans) para predecir a qué grupo pertenece una combinación de prendas
@csrf_exempt  # Exime del CSRF para facilitar pruebas desde el frontend o Postman
def recommend_outfit_ai(request):
    if request.method == 'POST':
        try:
            # Parseamos el JSON del body
            data = json.loads(request.body)

            # Usamos el modelo entrenado para predecir el grupo
            group = predict_outfit_group(data)

            # Respondemos con el grupo recomendado
            return JsonResponse({'recommended_group': int(group)})

        except Exception as e:
            # En caso de error devolvemos el mensaje
            return JsonResponse({'error': str(e)}, status=400)

    # Si no es POST, retornamos error de método no permitido
    return JsonResponse({'error': 'Método no permitido'}, status=405)