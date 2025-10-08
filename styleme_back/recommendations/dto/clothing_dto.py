from dataclasses import dataclass
from typing import Optional


@dataclass
class ClothingDTO:
    """DTO para transferencia de datos de prendas"""
    tipo: str
    color: str
    temporada: str

    def to_dict(self):
        return {
            'tipo': self.tipo,
            'color': self.color,
            'temporada': self.temporada
        }

    @staticmethod
    def from_entity(prenda):
        """Convierte una entidad Prenda a DTO"""
        return ClothingDTO(
            tipo=prenda.tipo,
            color=prenda.color,
            temporada=prenda.temporada
        )


@dataclass
class ClothingDetectionDTO:
    """DTO para detección de prendas desde imágenes"""
    tipo: str
    confidence: float
    bounding_box: list

    def to_dict(self):
        return {
            'tipo': self.tipo,
            'confidence': self.confidence,
            'bounding_box': self.bounding_box
        }
