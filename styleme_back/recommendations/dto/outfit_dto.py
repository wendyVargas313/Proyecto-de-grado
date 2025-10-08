from dataclasses import dataclass
from typing import List
from .clothing_dto import ClothingDTO


@dataclass
class OutfitDTO:
    """DTO para transferencia de datos de outfits"""
    nombre: str
    prendas: List[ClothingDTO]

    def to_dict(self):
        return {
            'nombre': self.nombre,
            'prendas': [prenda.to_dict() for prenda in self.prendas]
        }

    @staticmethod
    def from_entity(outfit):
        """Convierte una entidad Outfit a DTO"""
        return OutfitDTO(
            nombre=outfit.nombre,
            prendas=[ClothingDTO.from_entity(p) for p in outfit.prendas]
        )


@dataclass
class OutfitRecommendationRequestDTO:
    """DTO para solicitud de recomendación de outfits"""
    email: str

    @staticmethod
    def from_request(data):
        return OutfitRecommendationRequestDTO(
            email=data.get('email')
        )

    def validate(self):
        """Valida los datos del DTO"""
        if not self.email:
            raise ValueError("Email es requerido")
        return True


@dataclass
class OutfitAIRequestDTO:
    """DTO para solicitud de recomendación con IA"""
    features: dict

    @staticmethod
    def from_request(data):
        return OutfitAIRequestDTO(
            features=data
        )

    def validate(self):
        """Valida los datos del DTO"""
        if not self.features or not isinstance(self.features, dict):
            raise ValueError("Features debe ser un diccionario válido")
        return True
