from mongoengine import EmbeddedDocument, StringField, ListField, EmbeddedDocumentField
from .clothing import Prenda

class Outfit(EmbeddedDocument):
    nombre = StringField(required=True)
    prendas = ListField(EmbeddedDocumentField(Prenda))