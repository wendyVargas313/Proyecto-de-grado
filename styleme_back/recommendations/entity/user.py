import bcrypt
from mongoengine import Document, StringField, BooleanField, DateTimeField, ListField
from django.utils import timezone


class Usuario(Document):
    nombre = StringField(required=True, max_length=100)
    correo = StringField(required=True, unique=True, max_length=255)
    password = StringField(required=True, default='')
    is_active = BooleanField(default=True)
    is_verified = BooleanField(default=False)
    preferencias_color = ListField(StringField(), default=list)
    preferencias_tipo = ListField(StringField(), default=list)
    preferencias_temporada = ListField(StringField(), default=list)
    guardarropa = ListField(default=list)
    outfits_generados = ListField(default=list)
    created_at = DateTimeField(default=timezone.now)
    last_login = DateTimeField(null=True)

    meta = {
        'collection': 'usuarios',
        'indexes': ['correo']
    }

    def set_password(self, raw_password):
        salt = bcrypt.gensalt()
        self.password = bcrypt.hashpw(
            raw_password.encode('utf-8'), salt
        ).decode('utf-8')

    def check_password(self, raw_password):
        try:
            return bcrypt.checkpw(
                raw_password.encode('utf-8'),
                self.password.encode('utf-8')
            )
        except Exception:
            return False

    def update_last_login(self):
        self.last_login = timezone.now()
        self.save()
