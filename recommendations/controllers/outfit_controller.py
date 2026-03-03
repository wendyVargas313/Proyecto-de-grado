from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from recommendations.services.outfit_service import OutfitService
from recommendations.dto.outfit_dto import OutfitRecommendationRequestDTO, OutfitAIRequestDTO
import json


# Instancia del servicio
outfit_service = OutfitService()


@api_view(['POST'])
def recommend_outfit(request):
    """
    Endpoint que genera outfits basados en las prendas del usuario y sus preferencias
    """
    try:
        # Crear DTO desde la solicitud
        request_dto = OutfitRecommendationRequestDTO.from_request(request.data)
        
        # Validar datos
        request_dto.validate()

        # Llamar al servicio para generar outfits
        outfits = outfit_service.generate_outfits_for_user(request_dto.email)

        # Construir respuesta
        return Response({
            "outfits": [
                {
                    "name": outfit.nombre,
                    "items": [
                        {
                            "type": prenda.tipo,
                            "color": prenda.color,
                            "season": prenda.temporada
                        }
                        for prenda in outfit.prendas
                    ]
                }
                for outfit in outfits
            ]
        }, status=200)

    except ValueError as e:
        return Response({"error": str(e)}, status=400)
    except Exception as e:
        return Response({"error": f"Error interno: {str(e)}"}, status=500)


@csrf_exempt
def recommend_outfit_ai(request):
    """
    Endpoint que utiliza el modelo IA (KMeans) para predecir a qué grupo pertenece una combinación de prendas
    """
    if request.method == 'POST':
        try:
            # Parsear JSON del body
            data = json.loads(request.body)

            # Crear DTO desde la solicitud
            request_dto = OutfitAIRequestDTO.from_request(data)
            
            # Validar datos
            request_dto.validate()

            # Llamar al servicio para predecir el grupo
            group = outfit_service.predict_outfit_group_ai(request_dto.features)

            # Responder con el grupo recomendado
            return JsonResponse({'recommended_group': group}, status=200)

        except ValueError as e:
            return JsonResponse({'error': str(e)}, status=400)
        except Exception as e:
            return JsonResponse({'error': f"Error interno: {str(e)}"}, status=500)

    return JsonResponse({'error': 'Método no permitido'}, status=405)