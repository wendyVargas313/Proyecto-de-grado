from django.test import TestCase, Client
from django.urls import reverse
import json
from recommendations.entity.user import Usuario
from recommendations.services.auth_service import AuthService
from recommendations.dto.auth_dto import RegisterRequestDTO, LoginRequestDTO


class AuthTestCase(TestCase):
    """Test cases para el sistema de autenticación"""

    def setUp(self):
        """Configuración inicial para los tests"""
        self.client = Client()
        self.auth_service = AuthService()
        
        # Datos de prueba
        self.test_user_data = {
            'nombre': 'Usuario Test',
            'correo': 'test@example.com',
            'password': 'password123',
            'confirm_password': 'password123'
        }

    def test_user_registration_success(self):
        """Test de registro exitoso"""
        response = self.client.post(
            '/auth/register/',
            data=json.dumps(self.test_user_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.content)
        self.assertTrue(data['success'])
        self.assertEqual(data['user']['correo'], self.test_user_data['correo'])
        self.assertEqual(data['user']['nombre'], self.test_user_data['nombre'])

    def test_user_registration_email_exists(self):
        """Test de registro con email ya existente"""
        # Crear usuario primero
        self.auth_service.register(RegisterRequestDTO(**self.test_user_data))
        
        # Intentar crear el mismo usuario nuevamente
        response = self.client.post(
            '/auth/register/',
            data=json.dumps(self.test_user_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.content)
        self.assertFalse(data['success'])
        self.assertIn('ya está registrado', data['message'])

    def test_user_registration_invalid_email(self):
        """Test de registro con email inválido"""
        invalid_data = self.test_user_data.copy()
        invalid_data['correo'] = 'email_invalido'
        
        response = self.client.post(
            '/auth/register/',
            data=json.dumps(invalid_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.content)
        self.assertFalse(data['success'])

    def test_user_registration_password_mismatch(self):
        """Test de registro con contraseñas que no coinciden"""
        invalid_data = self.test_user_data.copy()
        invalid_data['confirm_password'] = 'diferente'
        
        response = self.client.post(
            '/auth/register/',
            data=json.dumps(invalid_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.content)
        self.assertFalse(data['success'])
        self.assertIn('no coinciden', data['message'])

    def test_login_success(self):
        """Test de login exitoso"""
        # Registrar usuario primero
        self.auth_service.register(RegisterRequestDTO(**self.test_user_data))
        
        # Intentar login
        login_data = {
            'correo': self.test_user_data['correo'],
            'password': self.test_user_data['password']
        }
        
        response = self.client.post(
            '/auth/login/',
            data=json.dumps(login_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.content)
        self.assertTrue(data['success'])
        self.assertEqual(data['user']['correo'], login_data['correo'])

    def test_login_invalid_credentials(self):
        """Test de login con credenciales inválidas"""
        login_data = {
            'correo': 'noexiste@example.com',
            'password': 'wrongpassword'
        }
        
        response = self.client.post(
            '/auth/login/',
            data=json.dumps(login_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 401)
        data = json.loads(response.content)
        self.assertFalse(data['success'])
        self.assertIn('inválidas', data['message'])

    def test_get_profile_success(self):
        """Test de obtener perfil exitoso"""
        # Registrar usuario primero
        register_response = self.auth_service.register(RegisterRequestDTO(**self.test_user_data))
        user_id = register_response.user['id']
        
        # Obtener perfil
        response = self.client.get(f'/auth/profile/{user_id}/')
        
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.content)
        self.assertTrue(data['success'])
        self.assertEqual(data['user']['correo'], self.test_user_data['correo'])

    def test_get_profile_not_found(self):
        """Test de obtener perfil con usuario inexistente"""
        response = self.client.get('/auth/profile/nonexistent_id/')
        
        self.assertEqual(response.status_code, 404)
        data = json.loads(response.content)
        self.assertFalse(data['success'])
        self.assertIn('no encontrado', data['message'])

    def test_change_password_success(self):
        """Test de cambio de contraseña exitoso"""
        # Registrar usuario primero
        register_response = self.auth_service.register(RegisterRequestDTO(**self.test_user_data))
        user_id = register_response.user['id']
        
        # Cambiar contraseña
        password_data = {
            'current_password': self.test_user_data['password'],
            'new_password': 'newpassword123'
        }
        
        response = self.client.put(
            f'/auth/change-password/{user_id}/',
            data=json.dumps(password_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.content)
        self.assertTrue(data['success'])

    def test_change_password_wrong_current(self):
        """Test de cambio de contraseña con contraseña actual incorrecta"""
        # Registrar usuario primero
        register_response = self.auth_service.register(RegisterRequestDTO(**self.test_user_data))
        user_id = register_response.user['id']
        
        # Intentar cambiar con contraseña actual incorrecta
        password_data = {
            'current_password': 'wrongpassword',
            'new_password': 'newpassword123'
        }
        
        response = self.client.put(
            f'/auth/change-password/{user_id}/',
            data=json.dumps(password_data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.content)
        self.assertFalse(data['success'])
        self.assertIn('incorrecta', data['message'])
