# 📸 API de Carga de Imágenes de Guardarropa

Documentación completa del endpoint para cargar imágenes de prendas.

---

## 📍 Endpoint

```
POST /api/detect-clothing/
```

---

## 📋 Descripción

Este endpoint permite a los usuarios subir una o varias imágenes de prendas. El sistema:
1. Valida el formato y tamaño de las imágenes
2. Detecta automáticamente las prendas usando YOLO
3. Sube las imágenes a MongoDB GridFS
4. Guarda las prendas detectadas en MongoDB con su ID y URL
5. Retorna información detallada de las prendas detectadas

---

## ✅ Criterios de Aceptación Implementados

- ✅ Acepta una o varias imágenes desde el dispositivo móvil
- ✅ Solo acepta formatos JPG y PNG
- ✅ Máximo 10 MB por imagen
- ✅ Almacena en MongoDB GridFS
- ✅ Guarda ID y URL en MongoDB
- ✅ Notifica éxito claramente
- ✅ Mensajes de error descriptivos

---

## 📥 Request

### Headers

```
Content-Type: multipart/form-data
```

### Body (Form Data)

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `email` | string | ✅ Sí | Email del usuario |
| `image` | file | ✅ Sí* | Imagen individual |
| `images` | file[] | ✅ Sí* | Múltiples imágenes |

*Nota: Enviar `image` para una sola imagen o `images` para múltiples

### Validaciones

- **Formato:** Solo JPG o PNG
- **Tamaño:** Máximo 10 MB por imagen
- **MIME Type:** `image/jpeg` o `image/png`

---

## 📤 Response

### ✅ Respuesta Exitosa (200 OK)

#### Una imagen procesada

```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente. Se procesaron 1 de 1 imagen(es)",
  "total_images": 1,
  "processed_images": 1,
  "total_prendas_detectadas": 2,
  "prendas": [
    {
      "tipo": "camiseta",
      "color": "desconocido",
      "temporada": "desconocido",
      "imagen_id": "67054abc123def456789",
      "imagen_url": "/api/images/67054abc123def456789",
      "fecha_agregada": "2025-10-08T19:00:00.000000",
      "confianza": "0.95"
    },
    {
      "tipo": "pantalón",
      "color": "desconocido",
      "temporada": "desconocido",
      "imagen_url": "https://storage.googleapis.com/your-bucket/wardrobe/user@example.com/user@example.com_uuid.jpg",
      "fecha_agregada": "2025-10-08T19:00:00.000000",
      "confianza": "0.89"
    }
  ]
}
```

#### Múltiples imágenes con advertencias

```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente. Se procesaron 2 de 3 imagen(es). 1 imagen(es) no se pudieron procesar",
  "total_images": 3,
  "processed_images": 2,
  "total_prendas_detectadas": 4,
  "prendas": [
    {
      "tipo": "camiseta",
      "color": "desconocido",
      "temporada": "desconocido",
      "imagen_url": "https://storage.googleapis.com/...",
      "fecha_agregada": "2025-10-08T19:00:00.000000",
      "confianza": "0.95"
    }
  ],
  "warnings": [
    {
      "image": "foto3.jpg",
      "error": "La imagen excede el tamaño máximo permitido de 10 MB. Tamaño actual: 12.45 MB"
    }
  ]
}
```

### ❌ Respuestas de Error

#### 400 Bad Request - Email faltante

```json
{
  "success": false,
  "error": "Email es requerido",
  "error_type": "MISSING_EMAIL"
}
```

#### 400 Bad Request - Imagen faltante

```json
{
  "success": false,
  "error": "No se proporcionó ninguna imagen",
  "error_type": "MISSING_IMAGE"
}
```

#### 400 Bad Request - Formato inválido

```json
{
  "success": false,
  "error": "Formato no válido. Solo se aceptan imágenes JPG o PNG. Formato recibido: GIF",
  "error_type": "INVALID_FORMAT"
}
```

#### 400 Bad Request - Archivo muy grande

```json
{
  "success": false,
  "error": "La imagen excede el tamaño máximo permitido de 10 MB. Tamaño actual: 12.45 MB",
  "error_type": "FILE_TOO_LARGE"
}
```

#### 400 Bad Request - Usuario no encontrado

```json
{
  "success": false,
  "error": "Usuario no encontrado",
  "error_type": "USER_NOT_FOUND"
}
```

#### 400 Bad Request - No se detectaron prendas

```json
{
  "success": false,
  "error": "No se detectaron prendas en la imagen. Por favor, intenta con otra imagen.",
  "error_type": "VALIDATION_ERROR"
}
```

#### 400 Bad Request - Error de almacenamiento

```json
{
  "success": false,
  "error": "Error al subir imagen a MongoDB: [detalles]",
  "error_type": "STORAGE_ERROR"
}
```

#### 400 Bad Request - Ninguna imagen procesada

```json
{
  "success": false,
  "error": "No se pudo procesar ninguna imagen",
  "error_type": "PROCESSING_FAILED",
  "details": [
    {
      "image": "foto1.jpg",
      "error": "Formato no válido"
    },
    {
      "image": "foto2.jpg",
      "error": "Archivo muy grande"
    }
  ]
}
```

#### 500 Internal Server Error

```json
{
  "success": false,
  "error": "Error interno del servidor. Por favor, intenta nuevamente.",
  "error_type": "INTERNAL_SERVER_ERROR"
}
```

#### 405 Method Not Allowed

```json
{
  "success": false,
  "error": "Método no permitido. Use POST",
  "error_type": "METHOD_NOT_ALLOWED"
}
```

---

## 🧪 Ejemplos de Uso

### cURL - Una imagen

```bash
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=usuario@example.com" \
  -F "image=@/ruta/a/imagen.jpg"
```

### cURL - Múltiples imágenes

```bash
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=usuario@example.com" \
  -F "images=@/ruta/a/imagen1.jpg" \
  -F "images=@/ruta/a/imagen2.png" \
  -F "images=@/ruta/a/imagen3.jpg"
```

### Python - requests

```python
import requests

url = "http://localhost:8000/api/detect-clothing/"

# Una imagen
files = {
    'image': open('imagen.jpg', 'rb')
}
data = {
    'email': 'usuario@example.com'
}

response = requests.post(url, files=files, data=data)
print(response.json())
```

### Python - Múltiples imágenes

```python
import requests

url = "http://localhost:8000/api/detect-clothing/"

files = [
    ('images', open('imagen1.jpg', 'rb')),
    ('images', open('imagen2.png', 'rb')),
    ('images', open('imagen3.jpg', 'rb'))
]
data = {
    'email': 'usuario@example.com'
}

response = requests.post(url, files=files, data=data)
print(response.json())
```

### JavaScript - Fetch API

```javascript
const formData = new FormData();
formData.append('email', 'usuario@example.com');
formData.append('image', fileInput.files[0]);

fetch('http://localhost:8000/api/detect-clothing/', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(data => {
  if (data.success) {
    console.log('✅ Éxito:', data.message);
    console.log('Prendas:', data.prendas);
  } else {
    console.error('❌ Error:', data.error);
  }
})
.catch(error => console.error('Error:', error));
```

### Flutter - http package

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> uploadClothingImage(String email, File imageFile) async {
  var uri = Uri.parse('http://localhost:8000/api/detect-clothing/');
  var request = http.MultipartRequest('POST', uri);
  
  // Agregar email
  request.fields['email'] = email;
  
  // Agregar imagen
  request.files.add(
    await http.MultipartFile.fromPath('image', imageFile.path)
  );
  
  // Enviar request
  var response = await request.send();
  var responseData = await response.stream.bytesToString();
  var jsonResponse = json.decode(responseData);
  
  if (jsonResponse['success']) {
    print('✅ ${jsonResponse['message']}');
    print('Prendas detectadas: ${jsonResponse['total_prendas_detectadas']}');
  } else {
    print('❌ Error: ${jsonResponse['error']}');
  }
}
```

---

## 🔍 Tipos de Error

| Código | error_type | Descripción |
|--------|-----------|-------------|
| `MISSING_EMAIL` | Email no proporcionado |
| `MISSING_IMAGE` | No se envió ninguna imagen |
| `INVALID_FORMAT` | Formato de imagen no válido (no JPG/PNG) |
| `FILE_TOO_LARGE` | Imagen excede 2 MB |
| `USER_NOT_FOUND` | Usuario no existe en la BD |
| `VALIDATION_ERROR` | Error de validación general |
| `STORAGE_ERROR` | Error al subir a Firebase Storage |
| `PROCESSING_FAILED` | No se pudo procesar ninguna imagen |
| `INTERNAL_SERVER_ERROR` | Error inesperado del servidor |
| `METHOD_NOT_ALLOWED` | Método HTTP no permitido |

---

## 📊 Flujo de Procesamiento

```
1. Cliente envía imagen(es) + email
         ↓
2. Validación de email
         ↓
3. Validación de imagen(es)
   - Formato (JPG/PNG)
   - Tamaño (≤ 10 MB)
   - MIME type
         ↓
4. Buscar usuario en MongoDB
         ↓
5. Guardar imagen temporal
         ↓
6. Detectar prendas con YOLO
         ↓
7. Subir imagen a MongoDB GridFS
         ↓
8. Crear entidades Prenda con ID y URL
         ↓
9. Guardar en MongoDB (colección usuarios)
         ↓
10. Limpiar archivos temporales
         ↓
11. Retornar respuesta JSON
```

---

## 🎯 Casos de Uso

### Caso 1: Usuario sube una foto de camiseta

**Request:**
```bash
POST /api/detect-clothing/
email: user@example.com
image: camiseta.jpg (1.2 MB, JPG)
```

**Response:**
```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente. Se procesaron 1 de 1 imagen(es)",
  "total_prendas_detectadas": 1,
  "prendas": [
    {
      "tipo": "camiseta",
      "imagen_url": "https://storage.googleapis.com/...",
      "confianza": "0.95"
    }
  ]
}
```

### Caso 2: Usuario sube múltiples fotos

**Request:**
```bash
POST /api/detect-clothing/
email: user@example.com
images: [foto1.jpg, foto2.png, foto3.jpg]
```

**Response:**
```json
{
  "success": true,
  "total_images": 3,
  "processed_images": 3,
  "total_prendas_detectadas": 5
}
```

### Caso 3: Imagen muy grande

**Request:**
```bash
POST /api/detect-clothing/
email: user@example.com
image: foto_grande.jpg (12 MB)
```

**Response:**
```json
{
  "success": false,
  "error": "La imagen excede el tamaño máximo permitido de 10 MB. Tamaño actual: 12.00 MB",
  "error_type": "FILE_TOO_LARGE"
}
```

### Caso 4: Formato inválido

**Request:**
```bash
POST /api/detect-clothing/
email: user@example.com
image: documento.pdf
```

**Response:**
```json
{
  "success": false,
  "error": "Formato no válido. Solo se aceptan imágenes JPG o PNG. Formato recibido: PDF",
  "error_type": "INVALID_FORMAT"
}
```

---

## 🔐 Seguridad

- ✅ Validación de formato de archivo
- ✅ Validación de tamaño de archivo
- ✅ Validación de MIME type
- ✅ Nombres de archivo únicos (UUID)
- ✅ Archivos temporales eliminados después de procesar
- ✅ Logging de errores
- ⚠️ CSRF deshabilitado (para desarrollo)

**Para producción:**
- Implementar autenticación JWT
- Habilitar CSRF protection
- Rate limiting
- Validación de usuario autenticado

---

## 📝 Notas Importantes

1. **Archivos temporales:** Se guardan en `recommendations/media/temp/` y se eliminan automáticamente
2. **MongoDB GridFS:** Las imágenes se almacenan en GridFS con metadata del usuario
3. **Detección YOLO:** Si no se detectan prendas, la imagen no se guarda
4. **Múltiples prendas:** Una imagen puede contener múltiples prendas detectadas
5. **URLs relativas:** Las imágenes se sirven desde `/api/images/{file_id}`

---

## 🐛 Troubleshooting

### Problema: "Usuario no encontrado"
**Solución:** Crear el usuario primero en MongoDB

### Problema: "Error al subir a MongoDB"
**Solución:** Verificar que MongoDB esté corriendo y accesible

### Problema: "No se detectaron prendas"
**Solución:** Usar imágenes más claras con prendas visibles

---

## 📚 Ver También

- [MONGODB_GRIDFS_SETUP.md](./MONGODB_GRIDFS_SETUP.md) - Configuración de GridFS
- [ARQUITECTURA_MODULAR.md](./ARQUITECTURA_MODULAR.md) - Arquitectura del proyecto

---

**¿Preguntas o problemas?** Consulta los logs en `styleme_back/logs/django.log`
