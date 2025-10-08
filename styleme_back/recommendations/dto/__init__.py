"""
DTOs (Data Transfer Objects) para el módulo de recomendaciones
"""
from .clothing_dto import ClothingDTO, ClothingDetectionDTO
from .outfit_dto import OutfitDTO, OutfitRecommendationRequestDTO, OutfitAIRequestDTO
from .user_dto import UserDTO, UserPreferencesDTO, ImageUploadRequestDTO

__all__ = [
    'ClothingDTO',
    'ClothingDetectionDTO',
    'OutfitDTO',
    'OutfitRecommendationRequestDTO',
    'OutfitAIRequestDTO',
    'UserDTO',
    'UserPreferencesDTO',
    'ImageUploadRequestDTO',
]
