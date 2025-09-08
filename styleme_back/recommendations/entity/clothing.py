from mongoengine import EmbeddedDocument, StringField

class Prenda(EmbeddedDocument):
    tipo = StringField(required=True)
    color = StringField(required=True)
    temporada = StringField(required=True)