# 🗄️ MongoDB GridFS - Almacenamiento de Imágenes

Este documento explica cómo funciona el almacenamiento de imágenes usando **MongoDB GridFS**.

---

## 📋 ¿Qué es GridFS?

**GridFS** es una especificación de MongoDB para almacenar y recuperar archivos que exceden el límite de tamaño de documento BSON de 16 MB.

### Ventajas de GridFS

✅ **Todo en MongoDB** - No necesitas servicios externos  
✅ **Sin límite de tamaño** - Archivos de cualquier tamaño  
✅ **Metadata** - Puedes agregar información personalizada  
✅ **Streaming** - Lectura y escritura eficiente  
✅ **Backup integrado** - Se respalda con tu base de datos  

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────┐
│  Cliente (Flutter/Web)              │
│  - Sube imagen                      │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Backend Django                     │
│  - Valida imagen (formato, tamaño) │
│  - Detecta prendas con YOLO         │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  GridFSService                      │
│  - Sube imagen a GridFS             │
│  - Retorna file_id                  │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  MongoDB                            │
│  ┌─────────────────────────────┐   │
│  │ fs.files (metadata)         │   │
│  │ - _id                       │   │
│  │ - filename                  │   │
│  │ - content_type              │   │
│  │ - metadata.user_email       │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ fs.chunks (datos binarios)  │   │
│  │ - files_id                  │   │
│  │ - n (número de chunk)       │   │
│  │ - data (bytes)              │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## 🚀 Configuración

### 1. MongoDB debe estar corriendo

```bash
# Windows
net start MongoDB

# Linux/Mac
sudo systemctl start mongod

# Verificar
mongo
> show dbs
> exit
```

### 2. No se requiere configuración adicional

GridFS funciona automáticamente con tu instalación de MongoDB existente.

---

## 📊 Estructura de Datos

### Colecciones de GridFS

GridFS crea automáticamente dos colecciones:

#### `fs.files` - Metadata de archivos

```javascript
{
  "_id": ObjectId("..."),
  "filename": "user@example.com_uuid.jpg",
  "content_type": "image/jpeg",
  "length": 524288,  // Tamaño en bytes
  "upload_date": ISODate("2025-10-08T..."),
  "metadata": {
    "user_email": "user@example.com",
    "original_filename": "foto.jpg",
    "folder": "wardrobe",
    "upload_date": ISODate("2025-10-08T...")
  }
}
```

#### `fs.chunks` - Datos binarios

```javascript
{
  "_id": ObjectId("..."),
  "files_id": ObjectId("..."),  // Referencia a fs.files
  "n": 0,  // Número de chunk (0, 1, 2...)
  "data": BinData(...)  // Datos binarios (máx 255 KB por chunk)
}
```

---

## 🔧 Uso del API

### Subir Imagen

**Endpoint:** `POST /api/detect-clothing/`

```bash
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=user@example.com" \
  -F "image=@foto.jpg"
```

**Respuesta:**

```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente",
  "prendas": [
    {
      "tipo": "camiseta",
      "color": "desconocido",
      "temporada": "desconocido",
      "imagen_id": "67054abc123def456789",
      "imagen_url": "/api/images/67054abc123def456789",
      "confianza": "0.95"
    }
  ]
}
```

### Obtener Imagen

**Endpoint:** `GET /api/images/{file_id}`

```bash
curl http://localhost:8000/api/images/67054abc123def456789
```

Retorna la imagen directamente (JPEG o PNG).

### Obtener Metadata

**Endpoint:** `GET /api/images/{file_id}/metadata`

```bash
curl http://localhost:8000/api/images/67054abc123def456789/metadata
```

**Respuesta:**

```json
{
  "success": true,
  "metadata": {
    "filename": "user@example.com_uuid.jpg",
    "content_type": "image/jpeg",
    "length": 524288,
    "upload_date": "2025-10-08T19:00:00",
    "metadata": {
      "user_email": "user@example.com",
      "original_filename": "foto.jpg",
      "folder": "wardrobe"
    }
  }
}
```

---

## 💻 Uso en el Código

### Subir Imagen

```python
from recommendations.services.gridfs_service import GridFSService

gridfs_service = GridFSService()

# Subir imagen
file_id = gridfs_service.upload_image(
    file_data=image_file,
    file_name="foto.jpg",
    user_email="user@example.com",
    content_type="image/jpeg"
)

# Generar URL
image_url = gridfs_service.get_image_url(file_id)
# Resultado: "/api/images/67054abc123def456789"
```

### Obtener Imagen

```python
# Obtener bytes de la imagen
image_data = gridfs_service.get_image(file_id)

# Obtener metadata
metadata = gridfs_service.get_image_metadata(file_id)
```

### Eliminar Imagen

```python
success = gridfs_service.delete_image(file_id)
```

### Listar Imágenes de Usuario

```python
images = gridfs_service.list_user_images("user@example.com")

# Resultado:
# [
#   {
#     "file_id": "67054abc123def456789",
#     "filename": "foto1.jpg",
#     "content_type": "image/jpeg",
#     "upload_date": datetime(...),
#     "url": "/api/images/67054abc123def456789"
#   },
#   ...
# ]
```

---

## 🔍 Consultas Útiles en MongoDB

### Ver todas las imágenes

```javascript
use styleme_db

// Ver metadata
db.fs.files.find().pretty()

// Ver imágenes de un usuario
db.fs.files.find({"metadata.user_email": "user@example.com"})

// Contar imágenes
db.fs.files.count()

// Ver tamaño total
db.fs.files.aggregate([
  {$group: {_id: null, total: {$sum: "$length"}}}
])
```

### Eliminar imagen específica

```javascript
// Por file_id
db.fs.files.deleteOne({_id: ObjectId("67054abc123def456789")})
db.fs.chunks.deleteMany({files_id: ObjectId("67054abc123def456789")})
```

### Eliminar todas las imágenes de un usuario

```javascript
// Obtener IDs
var fileIds = db.fs.files.find(
  {"metadata.user_email": "user@example.com"}
).map(f => f._id)

// Eliminar
db.fs.files.deleteMany({_id: {$in: fileIds}})
db.fs.chunks.deleteMany({files_id: {$in: fileIds}})
```

---

## 📏 Límites y Consideraciones

### Tamaños

- **Documento BSON:** 16 MB máximo
- **Chunk GridFS:** 255 KB por defecto
- **Archivo GridFS:** Sin límite práctico

### Rendimiento

- ✅ **Bueno para:** Archivos < 16 MB (como imágenes de prendas)
- ⚠️ **Considerar alternativas para:** Archivos muy grandes (> 100 MB)

### Validaciones Implementadas

- ✅ Formato: Solo JPG/PNG
- ✅ Tamaño máximo: 2 MB por imagen
- ✅ MIME type validado

---

## 🎯 Ventajas vs Firebase Storage

| Característica | GridFS | Firebase Storage |
|----------------|--------|------------------|
| **Configuración** | ✅ Ninguna (ya tienes MongoDB) | ❌ Cuenta, credenciales, SDK |
| **Costo** | ✅ Gratis (tu servidor) | ⚠️ Pago después de 5GB |
| **Backup** | ✅ Integrado con MongoDB | ❌ Separado |
| **Dependencias** | ✅ Solo pymongo | ❌ firebase-admin |
| **Complejidad** | ✅ Simple | ⚠️ Configuración externa |
| **Escalabilidad** | ⚠️ Limitada por servidor | ✅ Ilimitada |

---

## 🧪 Probar GridFS

### Script de Prueba

```python
# test_gridfs.py
from recommendations.services.gridfs_service import GridFSService

try:
    gridfs_service = GridFSService()
    gridfs_service.initialize()
    print("✅ GridFS configurado correctamente")
    
    # Probar subida
    with open('test_image.jpg', 'rb') as f:
        file_id = gridfs_service.upload_image(
            f, 
            'test.jpg', 
            'test@example.com'
        )
        print(f"✅ Imagen subida: {file_id}")
        
        # Probar descarga
        data = gridfs_service.get_image(file_id)
        print(f"✅ Imagen descargada: {len(data)} bytes")
        
        # Eliminar
        gridfs_service.delete_image(file_id)
        print("✅ Imagen eliminada")
        
except Exception as e:
    print(f"❌ Error: {e}")
```

Ejecutar:
```bash
python manage.py shell < test_gridfs.py
```

---

## 🐛 Solución de Problemas

### Error: "No module named 'gridfs'"

GridFS viene incluido con pymongo, pero asegúrate:

```bash
pip install pymongo
```

### Error: "Connection refused"

MongoDB no está corriendo:

```bash
# Windows
net start MongoDB

# Linux
sudo systemctl start mongod
```

### Error: "File not found"

El `file_id` no existe o es inválido:

```python
# Verificar que el ID sea válido
from bson import ObjectId
try:
    ObjectId(file_id)
except:
    print("ID inválido")
```

### Imágenes no se muestran

Verifica que el endpoint esté registrado:

```python
# En urls.py
path('images/<str:file_id>', serve_image, name='serve_image'),
```

---

## 📊 Monitoreo

### Ver uso de espacio

```javascript
use styleme_db

// Tamaño de fs.files
db.fs.files.stats()

// Tamaño de fs.chunks
db.fs.chunks.stats()

// Tamaño total
db.stats()
```

### Logs

Los logs se guardan en `styleme_back/logs/django.log`:

```bash
tail -f logs/django.log
```

---

## 🔐 Seguridad

### Recomendaciones

1. **Validar siempre el formato y tamaño** ✅ (Ya implementado)
2. **Autenticación:** Verificar que el usuario tenga permiso
3. **Rate limiting:** Limitar subidas por usuario/tiempo
4. **Virus scan:** Para producción, escanear archivos

### Ejemplo de Autenticación

```python
# En imagen_controller.py
def detect_clothing_view(request):
    # Verificar autenticación
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'No autenticado'}, status=401)
    
    # Verificar que el email coincida con el usuario
    email = request.POST.get('email')
    if email != request.user.email:
        return JsonResponse({'error': 'No autorizado'}, status=403)
    
    # ... resto del código
```

---

## 📚 Referencias

- [MongoDB GridFS Documentation](https://www.mongodb.com/docs/manual/core/gridfs/)
- [PyMongo GridFS API](https://pymongo.readthedocs.io/en/stable/api/gridfs/)
- [GridFS Specification](https://github.com/mongodb/specifications/blob/master/source/gridfs/gridfs-spec.rst)

---

## ✅ Checklist

- [x] MongoDB instalado y corriendo
- [x] GridFSService implementado
- [x] Endpoint de subida funcionando
- [x] Endpoint para servir imágenes
- [x] Validaciones de formato y tamaño
- [x] Metadata personalizada
- [x] Manejo de errores
- [x] Logging implementado

---

**🎉 ¡GridFS está listo para usar! Todo se almacena en MongoDB sin dependencias externas.**
