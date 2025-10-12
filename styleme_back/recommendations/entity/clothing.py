from mongoengine import EmbeddedDocument, StringField, DateTimeField
from datetime import datetime


class Prenda(EmbeddedDocument):
    tipo = StringField(required=True)
    color = StringField(required=True)
    temporada = StringField(required=True)
    imagen_id = StringField()  # ID de la imagen en GridFS
    imagen_url = StringField()  # URL para acceder a la imagen (/api/images/{id})
    fecha_agregada = DateTimeField(default=datetime.utcnow)  # Fecha de creación
    confianza = StringField()  # Nivel de confianza de la detección (opcional)