from dataclasses import dataclass
from typing import List, Optional
from .clothing_dto import ClothingDTO
from .outfit_dto import OutfitDTO


@dataclass
class UserPreferencesDTO:
    """DTO para preferencias del usuario"""
    color: List[str]
    tipo: List[str]
    temporada: List[str]

    def to_dict(self):
        return {
            'color': self.color,
            'tipo': self.tipo,
            'temporada': self.temporada
        }


@dataclass
class UserDTO:
    """DTO para transferencia de datos de usuario"""
    nombre: str
    correo: str
    preferencias_color: List[str]
    preferencias_tipo: List[str]
    preferencias_temporada: List[str]
    guardarropa: List[ClothingDTO]
    outfits_generados: List[OutfitDTO]

    def to_dict(self):
        return {
            'nombre': self.nombre,
            'correo': self.correo,
            'preferencias_color': self.preferencias_color,
            'preferencias_tipo': self.preferencias_tipo,
            'preferencias_temporada': self.preferencias_temporada,
            'guardarropa': [p.to_dict() for p in self.guardarropa],
            'outfits_generados': [o.to_dict() for o in self.outfits_generados]
        }

    @staticmethod
    def from_entity(user):
        """Convierte una entidad Usuario a DTO"""
        return UserDTO(
            nombre=user.nombre,
            correo=user.correo,
            preferencias_color=user.preferencias_color,
            preferencias_tipo=user.preferencias_tipo,
            preferencias_temporada=user.preferencias_temporada,
            guardarropa=[ClothingDTO.from_entity(p) for p in user.guardarropa],
            outfits_generados=[OutfitDTO.from_entity(o) for o in user.outfits_generados]
        )


@dataclass
class ImageUploadRequestDTO:
    """DTO para solicitud de carga de imagen"""
    email: str
    image_path: str

    def validate(self):
        """Valida los datos del DTO"""
        if not self.email:
            raise ValueError("Email es requerido")
        if not self.image_path:
            raise ValueError("Imagen es requerida")
        return True
