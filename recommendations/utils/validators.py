import re
from typing import Optional


def validate_email(email: str) -> bool:
    """
    Valida si un correo electrónico tiene un formato válido
    
    Args:
        email: Correo electrónico a validar
        
    Returns:
        True si es válido, False otherwise
    """
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None


def validate_password_strength(password: str) -> dict:
    """
    Valida la fortaleza de una contraseña
    
    Args:
        password: Contraseña a validar
        
    Returns:
        Diccionario con resultado de validación
    """
    result = {
        'is_valid': True,
        'errors': []
    }
    
    if len(password) < 6:
        result['is_valid'] = False
        result['errors'].append('La contraseña debe tener al menos 6 caracteres')
    
    if len(password) > 128:
        result['is_valid'] = False
        result['errors'].append('La contraseña no puede tener más de 128 caracteres')
    
    # Opcional: requerir al menos una letra y un número
    if not re.search(r'[a-zA-Z]', password):
        result['errors'].append('La contraseña debe contener al menos una letra')
    
    if not re.search(r'\d', password):
        result['errors'].append('La contraseña debe contener al menos un número')
    
    if result['errors']:
        result['is_valid'] = False
    
    return result


def validate_name(name: str) -> dict:
    """
    Valida un nombre de usuario
    
    Args:
        name: Nombre a validar
        
    Returns:
        Diccionario con resultado de validación
    """
    result = {
        'is_valid': True,
        'errors': []
    }
    
    if not name or len(name.strip()) < 2:
        result['is_valid'] = False
        result['errors'].append('El nombre debe tener al menos 2 caracteres')
    
    if len(name.strip()) > 100:
        result['is_valid'] = False
        result['errors'].append('El nombre no puede tener más de 100 caracteres')
    
    # Permitir solo letras, espacios y algunos caracteres especiales
    if not re.match(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s\-\.]+$', name):
        result['is_valid'] = False
        result['errors'].append('El nombre contiene caracteres inválidos')
    
    if result['errors']:
        result['is_valid'] = False
    
    return result


def sanitize_string(text: str) -> str:
    """
    Limpia y sanitiza un string
    
    Args:
        text: Texto a sanitizar
        
    Returns:
        Texto sanitizado
    """
    if not text:
        return ''
    
    # Eliminar espacios extras
    text = text.strip()
    
    # Convertir a lowercase si es email
    if '@' in text:
        text = text.lower()
    
    return text


def generate_user_id() -> str:
    """
    Genera un ID único para usuario (placeholder para futuras implementaciones)
    
    Returns:
        ID único
    """
    import uuid
    return str(uuid.uuid4())
