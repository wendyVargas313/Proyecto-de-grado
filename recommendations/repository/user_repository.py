from recommendations.entity.user import Usuario
from recommendations.entity.clothing import Prenda
from recommendations.entity.outfit import Outfit
from typing import Optional, List


class UserRepository:
    """Repositorio para operaciones de acceso a datos de usuarios"""

    @staticmethod
    def find_by_email(email: str) -> Optional[Usuario]:
        """
        Busca un usuario por su correo electrónico
        
        Args:
            email: Correo del usuario
            
        Returns:
            Usuario encontrado o None
        """
        return Usuario.objects(correo=email).first()

    @staticmethod
    def find_by_id(user_id: str) -> Optional[Usuario]:
        """
        Busca un usuario por su ID
        
        Args:
            user_id: ID del usuario
            
        Returns:
            Usuario encontrado o None
        """
        return Usuario.objects(id=user_id).first()

    @staticmethod
    def create(nombre: str, correo: str) -> Usuario:
        """
        Crea un nuevo usuario
        
        Args:
            nombre: Nombre del usuario
            correo: Correo del usuario
            
        Returns:
            Usuario creado
        """
        user = Usuario(nombre=nombre, correo=correo)
        user.save()
        return user

    @staticmethod
    def save(user: Usuario) -> Usuario:
        """
        Guarda o actualiza un usuario
        
        Args:
            user: Usuario a guardar
            
        Returns:
            Usuario guardado
        """
        user.save()
        return user

    @staticmethod
    def add_clothing_to_wardrobe(user: Usuario, prendas: List[Prenda]) -> Usuario:
        """
        Agrega prendas al guardarropa del usuario
        
        Args:
            user: Usuario
            prendas: Lista de prendas a agregar
            
        Returns:
            Usuario actualizado
        """
        user.guardarropa.extend(prendas)
        user.save()
        return user

    @staticmethod
    def save_outfits(user: Usuario, outfits: List[Outfit]) -> Usuario:
        """
        Guarda los outfits generados del usuario
        
        Args:
            user: Usuario
            outfits: Lista de outfits generados
            
        Returns:
            Usuario actualizado
        """
        user.outfits_generados = outfits
        user.save()
        return user

    @staticmethod
    def get_wardrobe(user: Usuario) -> List[Prenda]:
        """
        Obtiene el guardarropa del usuario
        
        Args:
            user: Usuario
            
        Returns:
            Lista de prendas del guardarropa
        """
        return user.guardarropa

    @staticmethod
    def get_preferences(user: Usuario) -> dict:
        """
        Obtiene las preferencias del usuario
        
        Args:
            user: Usuario
            
        Returns:
            Diccionario con las preferencias
        """
        return {
            "color": user.preferencias_color,
            "tipo": user.preferencias_tipo,
            "temporada": user.preferencias_temporada,
        }

    @staticmethod
    def delete(user: Usuario) -> bool:
        """
        Elimina un usuario
        
        Args:
            user: Usuario a eliminar
            
        Returns:
            True si se eliminó correctamente
        """
        user.delete()
        return True

    @staticmethod
    def get_all() -> List[Usuario]:
        """
        Obtiene todos los usuarios
        
        Returns:
            Lista de todos los usuarios
        """
        return list(Usuario.objects.all())
