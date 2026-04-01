import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from recommendations.services.auth_service import AuthService as _AuthService

_auth_service = _AuthService()


def _user_to_dict(user):
    return {
        'id': str(user.id),
        'nombre': user.nombre,
        'email': user.correo,
        'is_active': user.is_active,
        'preferencias_color': user.preferencias_color,
        'preferencias_tipo': user.preferencias_tipo,
        'preferencias_temporada': user.preferencias_temporada,
    }


@csrf_exempt
@require_http_methods(['POST'])
def register_view(request):
    try:
        data = json.loads(request.body)
        nombre = data.get('nombre', '').strip()
        email = data.get('email', '').strip()
        password = data.get('password', '')
        user = _auth_service.register(nombre, email, password)
        return JsonResponse({
            'success': True,
            'message': 'Usuario registrado exitosamente',
            'user': _user_to_dict(user)
        }, status=201)
    except ValueError as e:
        return JsonResponse({'success': False, 'message': str(e)}, status=400)
    except Exception as e:
        import traceback
        traceback.print_exc()
        return JsonResponse({'success': False, 'message': f'Error: {str(e)}'}, status=500)


@csrf_exempt
@require_http_methods(['POST'])
def login_view(request):
    try:
        data = json.loads(request.body)
        email = data.get('email', '').strip()
        password = data.get('password', '')
        user, token = _auth_service.login(email, password)
        return JsonResponse({
            'success': True,
            'message': 'Login exitoso',
            'token': token,
            'user': _user_to_dict(user)
        }, status=200)
    except ValueError as e:
        return JsonResponse({'success': False, 'message': str(e)}, status=401)
    except Exception as e:
        import traceback
        traceback.print_exc()
        return JsonResponse({'success': False, 'message': f'Error: {str(e)}'}, status=500)


@csrf_exempt
@require_http_methods(['POST'])
def logout_view(request):
    return JsonResponse({'success': True, 'message': 'Logout exitoso'}, status=200)
