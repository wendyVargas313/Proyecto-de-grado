# ✅ Solución: Soporte para Imágenes WEBP

## Problema Identificado

El backend rechazaba imágenes en formato WEBP con el error:
```
Formato no válido. Solo se aceptan imágenes JPG o PNG. Formato recibido: WEBP
```

## Causa

Android (especialmente versiones recientes) convierte automáticamente las imágenes de la galería a formato WEBP para ahorrar espacio. El backend solo aceptaba JPG y PNG.

## Solución Aplicada

Actualizado `recommendations/services/imagen_service.py`:

```python
# Antes:
ALLOWED_FORMATS = ['jpg', 'jpeg', 'png']
ALLOWED_MIME_TYPES = ['image/jpeg', 'image/png']

# Después:
ALLOWED_FORMATS = ['jpg', 'jpeg', 'png', 'webp']
ALLOWED_MIME_TYPES = ['image/jpeg', 'image/png', 'image/webp']
```

## Formatos Soportados Ahora

- ✅ JPG / JPEG
- ✅ PNG
- ✅ WEBP (nuevo)

## Verificación

Django recarga automáticamente los cambios. No necesitas reiniciar el backend.

Prueba:
1. Selecciona una imagen desde la galería
2. Presiona "Detectar"
3. Debería funcionar correctamente

## Nota Técnica

WEBP es un formato moderno de Google que ofrece mejor compresión que JPG/PNG. Es el formato predeterminado en Android 12+.
