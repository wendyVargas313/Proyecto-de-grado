from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
import json
import logging

from recommendations.services.auth_service import AuthService
from recommendations.dto.auth_dto import RegisterRequestDTO, LoginRequestDTO

logger = logging.getLogger(__name__)


@csrf_exempt
@require_http_methods(["POST"])
def register_view(request):
    """
    Endpoint para registro de nuevos usuarios
    """
    try:
        data = json.loads(request.body)
        
        register_dto = RegisterRequestDTO(
            nombre=data.get('nombre', ''),
            correo=data.get('email', ''),
            password=data.get('password', ''),
            confirm_password=data.get('password', '')
        )
        
        auth_service = AuthService()
        response = auth_service.register(register_dto)
        
        # Convertir respuesta para que use 'email' en lugar de 'correo'
        response_dict = response.to_dict()
        if response.success and response_dict.get('user'):
            response_dict['user']['email'] = response_dict['user'].pop('correo')
        
        return JsonResponse(response_dict, status=201 if response.success else 400)
        
    except json.JSONDecodeError:
        return JsonResponse({
            'success': False,
            'message': 'Formato JSON inválido'
        }, status=400)
    except Exception as e:
        logger.error(f"Error en register_view: {str(e)}")
        return JsonResponse({
            'success': False,
            'message': 'Error interno del servidor'
        }, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def login_view(request):
    """
    Endpoint para login de usuarios
    """
    try:
        data = json.loads(request.body)
        
        login_dto = LoginRequestDTO(
            correo=data.get('email', ''),
            password=data.get('password', '')
        )
        
        auth_service = AuthService()
        response = auth_service.login(login_dto)
        
        # Convertir respuesta para que use 'email' en lugar de 'correo'
        response_dict = response.to_dict()
        if response.success and response_dict.get('user'):
            response_dict['user']['email'] = response_dict['user'].pop('correo')
        
        return JsonResponse(response_dict, status=200 if response.success else 401)
        
    except json.JSONDecodeError:
        return JsonResponse({
            'success': False,
            'message': 'Formato JSON inválido'
        }, status=400)
    except Exception as e:
        logger.error(f"Error en login_view: {str(e)}")
        return JsonResponse({
            'success': False,
            'message': 'Error interno del servidor'
        }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def profile_view(request, user_id):
    """
    Endpoint para obtener el perfil de un usuario
    """
    try:
        auth_service = AuthService()
        response = auth_service.get_user_profile(user_id)
        
        # Convertir respuesta para que use 'email' en lugar de 'correo'
        response_dict = response.to_dict()
        if response.success and response_dict.get('user'):
            response_dict['user']['email'] = response_dict['user'].pop('correo')
        
        return JsonResponse(response_dict, status=200 if response.success else 404)
        
    except Exception as e:
        logger.error(f"Error en profile_view: {str(e)}")
        return JsonResponse({
            'success': False,
            'message': 'Error interno del servidor'
        }, status=500)


@csrf_exempt
@require_http_methods(["PUT"])
def change_password_view(request, user_id):
    """
    Endpoint para cambiar la contraseña de un usuario
    """
    try:
        data = json.loads(request.body)
        
        current_password = data.get('current_password', '')
        new_password = data.get('new_password', '')
        
        if not current_password or not new_password:
            return JsonResponse({
                'success': False,
                'message': 'Se requieren la contraseña actual y la nueva'
            }, status=400)
        
        auth_service = AuthService()
        response = auth_service.change_password(user_id, current_password, new_password)
        
        return JsonResponse(response.to_dict(), status=200 if response.success else 400)
        
    except json.JSONDecodeError:
        return JsonResponse({
            'success': False,
            'message': 'Formato JSON inválido'
        }, status=400)
    except Exception as e:
        logger.error(f"Error en change_password_view: {str(e)}")
        return JsonResponse({
            'success': False,
            'message': 'Error interno del servidor'
        }, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def logout_view(request, user_id):
    """
    Endpoint para logout de usuarios (básico, podría extenderse con tokens)
    """
    try:
        # Por ahora es un logout básico
        # En el futuro podría manejar invalidación de tokens
        logger.info(f"Usuario hizo logout: {user_id}")
        
        return JsonResponse({
            'success': True,
            'message': 'Logout exitoso'
        }, status=200)
        
    except Exception as e:
        logger.error(f"Error en logout_view: {str(e)}")
        return JsonResponse({
            'success': False,
            'message': 'Error interno del servidor'
        }, status=500)
