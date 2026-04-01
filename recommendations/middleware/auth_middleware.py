from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
import logging
from recommendations.repository.user_repository import UserRepository

logger = logging.getLogger(__name__)


class AuthMiddleware(MiddlewareMixin):
    """
    Middleware para verificar autenticación en endpoints protegidos
    """

    def process_request(self, request):
        """
        Procesa cada request para verificar autenticación si es necesario
        """
        # URLs que no requieren autenticación
        public_urls = [
            '/auth/register/',
            '/auth/login/',
        ]
        
        # Obtener la ruta de la request
        path = request.path
        
        # Si es una URL pública, continuar sin verificar
        if path in public_urls:
            return None
        
        # URLs que requieren autenticación
        protected_urls = [
            '/auth/profile/',
            '/auth/change-password/',
            '/auth/logout/',
            '/recommend/',
            '/recommend-outfit-ai/',
            '/detect-clothing/',
        ]
        
        # Verificar si la URL requiere autenticación
        if any(path.startswith(protected_url) for protected_url in protected_urls):
            # Para simplificar, por ahora verificamos un header de autorización
            # En el futuro se podría implementar JWT
            auth_header = request.META.get('HTTP_AUTHORIZATION')
            
            if not auth_header:
                return JsonResponse({
                    'success': False,
                    'message': 'Se requiere autenticación'
                }, status=401)
            
            # El formato esperado: "Bearer <user_id>"
            try:
                token_parts = auth_header.split(' ')
                if len(token_parts) != 2 or token_parts[0] != 'Bearer':
                    return JsonResponse({
                        'success': False,
                        'message': 'Formato de token inválido'
                    }, status=401)
                
                user_id = token_parts[1]
                
                # Verificar que el usuario existe
                user_repo = UserRepository()
                user = user_repo.find_by_id(user_id)
                
                if not user or not user.is_active:
                    return JsonResponse({
                        'success': False,
                        'message': 'Usuario no válido o inactivo'
                    }, status=401)
                
                # Agregar el usuario a la request para uso posterior
                request.user = user
                
            except Exception as e:
                logger.error(f"Error en middleware de autenticación: {str(e)}")
                return JsonResponse({
                    'success': False,
                    'message': 'Error de autenticación'
                }, status=401)
        
        return None
