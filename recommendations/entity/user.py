from mongoengine import Document, StringField, ListField, EmbeddedDocumentField, BooleanField, DateTimeField
from django.contrib.auth.hashers import make_password, check_password
from django.utils import timezone
from .clothing import Prenda
from .outfit import Outfit

class Usuario(Document):
    nombre = StringField(required=True)
    correo = StringField(required=True, unique=True)
    password = StringField(required=True)  # Contraseña hasheada
    is_active = BooleanField(default=True)
    is_verified = BooleanField(default=False)
    created_at = DateTimeField(default=timezone.now)
    last_login = DateTimeField(null=True)
    preferencias_color = ListField(StringField())
    preferencias_tipo = ListField(StringField())
    preferencias_temporada = ListField(StringField())
    guardarropa = ListField(EmbeddedDocumentField(Prenda))
    outfits_generados = ListField(EmbeddedDocumentField(Outfit))

    meta = {'collection': 'usuarios'}

    def set_password(self, raw_password):
        """Hashea y establece la contraseña"""
        self.password = make_password(raw_password)

    def check_password(self, raw_password):
        """Verifica si la contraseña es correcta"""
        return check_password(raw_password, self.password)

    def update_last_login(self):
        """Actualiza la fecha del último login"""
        self.last_login = timezone.now()
        self.save()

    @classmethod
    def create_user(cls, nombre, correo, password):
        """Crea un nuevo usuario con contraseña hasheada"""
        user = cls(nombre=nombre, correo=correo)
        user.set_password(password)
        user.save()
        return user