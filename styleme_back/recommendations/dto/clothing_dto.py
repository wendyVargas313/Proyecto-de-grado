from dataclasses import dataclass
from typing import Optional
from datetime import datetime


@dataclass
class ClothingDTO:
    """DTO para transferencia de datos de prendas"""
    tipo: str
    color: str
    temporada: str
    imagen_url: Optional[str] = None
    fecha_agregada: Optional[str] = None
    confianza: Optional[str] = None

    def to_dict(self):
        data = {
            'tipo': self.tipo,
            'color': self.color,
            'temporada': self.temporada
        }
        if self.imagen_url:
            data['imagen_url'] = self.imagen_url
        if self.fecha_agregada:
            data['fecha_agregada'] = self.fecha_agregada
        if self.confianza:
            data['confianza'] = self.confianza
        return data

    @staticmethod
    def from_entity(prenda):
        """Convierte una entidad Prenda a DTO"""
        return ClothingDTO(
            tipo=prenda.tipo,
            color=prenda.color,
            temporada=prenda.temporada,
            imagen_url=prenda.imagen_url if hasattr(prenda, 'imagen_url') else None,
            fecha_agregada=prenda.fecha_agregada.isoformat() if hasattr(prenda, 'fecha_agregada') and prenda.fecha_agregada else None,
            confianza=prenda.confianza if hasattr(prenda, 'confianza') else None
        )


@dataclass
class ClothingDetectionDTO:
    """DTO para detección de prendas desde imágenes"""
    tipo: str
    confidence: float
    bounding_box: list
    imagen_url: Optional[str] = None

    def to_dict(self):
        data = {
            'tipo': self.tipo,
            'confidence': self.confidence,
            'bounding_box': self.bounding_box
        }
        if self.imagen_url:
            data['imagen_url'] = self.imagen_url
        return data


@dataclass
class ImageUploadValidationDTO:
    """DTO para validación de carga de imágenes"""
    is_valid: bool
    error_message: Optional[str] = None
    file_size_mb: Optional[float] = None
    file_format: Optional[str] = None

    def to_dict(self):
        return {
            'is_valid': self.is_valid,
            'error_message': self.error_message,
            'file_size_mb': self.file_size_mb,
            'file_format': self.file_format
        }
