from recommendations.repository.user_repository import UserRepository
from recommendations.repository.outfit_repository import OutfitRepository
from recommendations.ia.recommender import generate_outfits, predict_outfit_group
from recommendations.dto.outfit_dto import OutfitDTO
from typing import List, Dict


class OutfitService:
    """Servicio para lógica de negocio relacionada con outfits"""

    def __init__(self):
        self.user_repository = UserRepository()
        self.outfit_repository = OutfitRepository()

    def generate_outfits_for_user(self, email: str) -> List[OutfitDTO]:
        """
        Genera outfits para un usuario basándose en su guardarropa y preferencias
        
        Args:
            email: Correo del usuario
            
        Returns:
            Lista de OutfitDTOs generados
            
        Raises:
            ValueError: Si el usuario no existe
        """
        # Buscar usuario
        user = self.user_repository.find_by_email(email)
        if not user:
            raise ValueError("Usuario no encontrado")

        # Obtener guardarropa y preferencias
        wardrobe = self.user_repository.get_wardrobe(user)
        preferences = self.user_repository.get_preferences(user)

        # Validar que el usuario tenga prendas
        if not wardrobe:
            raise ValueError("El usuario no tiene prendas en su guardarropa")

        # Generar outfits usando el algoritmo de IA
        outfits = generate_outfits(wardrobe, preferences)

        # Guardar los outfits generados
        self.user_repository.save_outfits(user, outfits)

        # Convertir a DTOs
        outfit_dtos = [OutfitDTO.from_entity(outfit) for outfit in outfits]

        return outfit_dtos

    def predict_outfit_group_ai(self, features: Dict) -> int:
        """
        Predice el grupo de outfit usando el modelo de IA (KMeans)
        
        Args:
            features: Diccionario con características del outfit
            
        Returns:
            Número del grupo predicho
            
        Raises:
            ValueError: Si las características son inválidas
        """
        if not features or not isinstance(features, dict):
            raise ValueError("Las características deben ser un diccionario válido")

        # Usar el modelo de IA para predecir el grupo
        group = predict_outfit_group(features)

        return int(group)

    def get_user_outfits(self, email: str) -> List[OutfitDTO]:
        """
        Obtiene los outfits generados de un usuario
        
        Args:
            email: Correo del usuario
            
        Returns:
            Lista de OutfitDTOs del usuario
            
        Raises:
            ValueError: Si el usuario no existe
        """
        user = self.user_repository.find_by_email(email)
        if not user:
            raise ValueError("Usuario no encontrado")

        # Convertir a DTOs
        outfit_dtos = [OutfitDTO.from_entity(outfit) for outfit in user.outfits_generados]

        return outfit_dtos

    def validate_outfit_combination(self, prendas: List) -> bool:
        """
        Valida que una combinación de prendas sea válida para un outfit
        
        Args:
            prendas: Lista de prendas
            
        Returns:
            True si la combinación es válida
        """
        if not prendas or len(prendas) == 0:
            return False

        # Validar que haya al menos una prenda de tipo superior
        tipos = [p.tipo for p in prendas]
        tipos_superiores = ['camiseta', 'blusa', 'suéter']
        
        tiene_superior = any(tipo in tipos_superiores for tipo in tipos)
        
        return tiene_superior
