from recommendations.repository.user_repository import UserRepository
from recommendations.dto.user_dto import UserDTO
from typing import Optional


class UserService:
    """Servicio para lógica de negocio relacionada con usuarios"""

    def __init__(self):
        self.user_repository = UserRepository()

    def get_user_by_email(self, email: str) -> Optional[UserDTO]:
        """
        Obtiene un usuario por su correo
        
        Args:
            email: Correo del usuario
            
        Returns:
            UserDTO o None si no existe
        """
        user = self.user_repository.find_by_email(email)
        if not user:
            return None

        return UserDTO.from_entity(user)

    def create_user(self, nombre: str, correo: str) -> UserDTO:
        """
        Crea un nuevo usuario
        
        Args:
            nombre: Nombre del usuario
            correo: Correo del usuario
            
        Returns:
            UserDTO del usuario creado
            
        Raises:
            ValueError: Si el usuario ya existe
        """
        # Verificar que no exista
        existing_user = self.user_repository.find_by_email(correo)
        if existing_user:
            raise ValueError("El usuario ya existe")

        # Crear usuario
        user = self.user_repository.create(nombre, correo)

        return UserDTO.from_entity(user)

    def user_exists(self, email: str) -> bool:
        """
        Verifica si un usuario existe
        
        Args:
            email: Correo del usuario
            
        Returns:
            True si existe
        """
        user = self.user_repository.find_by_email(email)
        return user is not None

    def get_user_wardrobe_count(self, email: str) -> int:
        """
        Obtiene la cantidad de prendas en el guardarropa del usuario
        
        Args:
            email: Correo del usuario
            
        Returns:
            Cantidad de prendas
            
        Raises:
            ValueError: Si el usuario no existe
        """
        user = self.user_repository.find_by_email(email)
        if not user:
            raise ValueError("Usuario no encontrado")

        return len(user.guardarropa)
