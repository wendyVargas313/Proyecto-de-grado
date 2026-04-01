import jwt
import datetime
from django.conf import settings
from recommendations.entity.user import Usuario

class AuthService:

    def register(self, nombre, email, password):
        if not nombre or not email or not password:
            raise ValueError('Todos los campos son requeridos')
        if len(password) < 6:
            raise ValueError('La contrasena debe tener al menos 6 caracteres')
        if Usuario.objects(correo=email).first():
            raise ValueError('El correo ya esta registrado')
        user = Usuario(nombre=nombre, correo=email)
        user.set_password(password)
        user.save()
        return user

    def login(self, email, password):
        if not email or not password:
            raise ValueError('Email y contrasena son requeridos')
        user = Usuario.objects(correo=email).first()
        if not user:
            raise ValueError('Credenciales invalidas')
        if not user.check_password(password):
            raise ValueError('Credenciales invalidas')
        if not user.is_active:
            raise ValueError('Usuario inactivo')
        user.update_last_login()
        token = self._generate_token(user)
        return user, token

    def _generate_token(self, user):
        payload = {
            'user_id': str(user.id),
            'email': str(user.correo),
            'exp': datetime.datetime.utcnow() + datetime.timedelta(days=7)
        }
        return jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')

    def get_user_by_id(self, user_id):
        from bson import ObjectId
        try:
            return Usuario.objects(id=ObjectId(user_id)).first()
        except Exception:
            return None
