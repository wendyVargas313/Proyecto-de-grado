from mongoengine import Document, StringField, ListField, EmbeddedDocumentField
from .clothing import Prenda
from .outfit import Outfit

class Usuario(Document):
    nombre = StringField(required=True)
    correo = StringField(required=True, unique=True)
    preferencias_color = ListField(StringField())
    preferencias_tipo = ListField(StringField())
    preferencias_temporada = ListField(StringField())
    guardarropa = ListField(EmbeddedDocumentField(Prenda))
    outfits_generados = ListField(EmbeddedDocumentField(Outfit))

    meta = {'collection': 'usuarios'}