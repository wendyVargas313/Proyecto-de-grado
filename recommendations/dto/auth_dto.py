from dataclasses import dataclass
from typing import Optional


@dataclass
class RegisterRequestDTO:
    """DTO para solicitud de registro"""
    nombre: str
    correo: str
    password: str
    confirm_password: str

    def validate(self):
        """Valida los datos del DTO"""
        if not self.nombre or len(self.nombre.strip()) < 2:
            raise ValueError("El nombre debe tener al menos 2 caracteres")
        
        if not self.correo or '@' not in self.correo:
            raise ValueError("El correo electrónico no es válido")
        
        if not self.password or len(self.password) < 6:
            raise ValueError("La contraseña debe tener al menos 6 caracteres")
        
        if self.password != self.confirm_password:
            raise ValueError("Las contraseñas no coinciden")
        
        return True


@dataclass
class LoginRequestDTO:
    """DTO para solicitud de login"""
    correo: str
    password: str

    def validate(self):
        """Valida los datos del DTO"""
        if not self.correo or '@' not in self.correo:
            raise ValueError("El correo electrónico no es válido")
        
        if not self.password:
            raise ValueError("La contraseña es requerida")
        
        return True


@dataclass
class AuthResponseDTO:
    """DTO para respuesta de autenticación"""
    success: bool
    message: str
    user: Optional[dict] = None
    token: Optional[str] = None

    def to_dict(self):
        return {
            'success': self.success,
            'message': self.message,
            'user': self.user,
            'token': self.token
        }


@dataclass
class UserResponseDTO:
    """DTO para respuesta de datos de usuario (sin contraseña)"""
    id: str
    nombre: str
    correo: str
    is_active: bool
    is_verified: bool
    created_at: str
    last_login: Optional[str] = None

    def to_dict(self):
        return {
            'id': self.id,
            'nombre': self.nombre,
            'correo': self.correo,
            'is_active': self.is_active,
            'is_verified': self.is_verified,
            'created_at': self.created_at,
            'last_login': self.last_login
        }

    @staticmethod
    def from_entity(user):
        """Convierte una entidad Usuario a DTO"""
        return UserResponseDTO(
            id=str(user.id),
            nombre=user.nombre,
            correo=user.correo,
            is_active=user.is_active,
            is_verified=user.is_verified,
            created_at=user.created_at.isoformat() if user.created_at else None,
            last_login=user.last_login.isoformat() if user.last_login else None
        )
