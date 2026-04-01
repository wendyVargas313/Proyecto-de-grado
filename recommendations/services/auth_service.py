from recommendations.repository.user_repository import UserRepository
from recommendations.entity.user import Usuario
from recommendations.dto.auth_dto import RegisterRequestDTO, LoginRequestDTO, AuthResponseDTO, UserResponseDTO
from django.utils import timezone
from django.conf import settings
import jwt
import datetime
import logging

logger = logging.getLogger(__name__)


class AuthService:
    """Servicio para lógica de negocio de autenticación"""

    def __init__(self):
        self.user_repository = UserRepository()

    def register(self, register_dto: RegisterRequestDTO) -> AuthResponseDTO:
        """
        Registra un nuevo usuario
        
        Args:
            register_dto: DTO con datos de registro
            
        Returns:
            AuthResponseDTO con resultado del registro
        """
        try:
            # Validar datos
            register_dto.validate()
            
            # Verificar si el usuario ya existe
            existing_user = self.user_repository.find_by_email(register_dto.correo)
            if existing_user:
                return AuthResponseDTO(
                    success=False,
                    message="El correo electrónico ya está registrado"
                )
            
            # Crear nuevo usuario
            user = Usuario.create_user(
                nombre=register_dto.nombre.strip(),
                correo=register_dto.correo.strip().lower(),
                password=register_dto.password
            )
            
            logger.info(f"Usuario registrado: {user.correo}")
            
            return AuthResponseDTO(
                success=True,
                message="Usuario registrado exitosamente",
                user=UserResponseDTO.from_entity(user).to_dict()
            )
            
        except ValueError as e:
            logger.warning(f"Error de validación en registro: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message=str(e)
            )
        except Exception as e:
            logger.error(f"Error en registro: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message="Error interno del servidor"
            )

    def login(self, login_dto: LoginRequestDTO) -> AuthResponseDTO:
        """
        Inicia sesión de un usuario
        
        Args:
            login_dto: DTO con datos de login
            
        Returns:
            AuthResponseDTO con resultado del login
        """
        try:
            # Validar datos
            login_dto.validate()
            
            # Buscar usuario por correo
            user = self.user_repository.find_by_email(login_dto.correo.strip().lower())
            if not user:
                return AuthResponseDTO(
                    success=False,
                    message="Credenciales inválidas"
                )
            
            # Verificar contraseña
            if not user.check_password(login_dto.password):
                return AuthResponseDTO(
                    success=False,
                    message="Credenciales inválidas"
                )
            
            # Verificar si el usuario está activo
            if not user.is_active:
                return AuthResponseDTO(
                    success=False,
                    message="La cuenta está desactivada"
                )
            
            # Actualizar último login
            user.update_last_login()

            logger.info(f"Usuario logueado: {user.correo}")

            # Generar token JWT
            payload = {
                'user_id': str(user.id),
                'email': str(user.correo),
                'exp': datetime.datetime.utcnow() + datetime.timedelta(days=7)
            }
            token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')

            return AuthResponseDTO(
                success=True,
                message="Login exitoso",
                user=UserResponseDTO.from_entity(user).to_dict(),
                token=token
            )
            
        except ValueError as e:
            logger.warning(f"Error de validación en login: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message=str(e)
            )
        except Exception as e:
            logger.error(f"Error en login: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message="Error interno del servidor"
            )

    def get_user_profile(self, user_id: str) -> AuthResponseDTO:
        """
        Obtiene el perfil de un usuario
        
        Args:
            user_id: ID del usuario
            
        Returns:
            AuthResponseDTO con datos del usuario
        """
        try:
            user = self.user_repository.find_by_id(user_id)
            if not user:
                return AuthResponseDTO(
                    success=False,
                    message="Usuario no encontrado"
                )
            
            return AuthResponseDTO(
                success=True,
                message="Perfil obtenido exitosamente",
                user=UserResponseDTO.from_entity(user).to_dict()
            )
            
        except Exception as e:
            logger.error(f"Error obteniendo perfil: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message="Error interno del servidor"
            )

    def change_password(self, user_id: str, current_password: str, new_password: str) -> AuthResponseDTO:
        """
        Cambia la contraseña de un usuario
        
        Args:
            user_id: ID del usuario
            current_password: Contraseña actual
            new_password: Nueva contraseña
            
        Returns:
            AuthResponseDTO con resultado del cambio
        """
        try:
            if len(new_password) < 6:
                return AuthResponseDTO(
                    success=False,
                    message="La nueva contraseña debe tener al menos 6 caracteres"
                )
            
            user = self.user_repository.find_by_id(user_id)
            if not user:
                return AuthResponseDTO(
                    success=False,
                    message="Usuario no encontrado"
                )
            
            # Verificar contraseña actual
            if not user.check_password(current_password):
                return AuthResponseDTO(
                    success=False,
                    message="La contraseña actual es incorrecta"
                )
            
            # Cambiar contraseña
            user.set_password(new_password)
            user.save()
            
            logger.info(f"Contraseña cambiada para usuario: {user.correo}")
            
            return AuthResponseDTO(
                success=True,
                message="Contraseña cambiada exitosamente"
            )
            
        except Exception as e:
            logger.error(f"Error cambiando contraseña: {str(e)}")
            return AuthResponseDTO(
                success=False,
                message="Error interno del servidor"
            )
