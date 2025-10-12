# 🧪 Guía de Verificación - Backend Carga de Imágenes

**Fecha:** 08 de Octubre, 2025  
**Endpoint:** `/api/detect-clothing/`

---

## ✅ Checklist Pre-Verificación

Antes de comenzar, asegúrate de tener:

- [ ] MongoDB instalado y corriendo
- [ ] Python 3.8+ instalado
- [ ] Entorno virtual activado
- [ ] Dependencias instaladas
- [ ] Usuario de prueba creado en MongoDB

---

## 🚀 Paso 1: Preparar el Entorno

### 1.1 Activar Entorno Virtual

```powershell
# Windows PowerShell
.\env\Scripts\activate

# Deberías ver (env) al inicio de la línea
```

### 1.2 Verificar MongoDB

```powershell
# Iniciar MongoDB (si no está corriendo)
net start MongoDB

# Verificar conexión
mongosh
# Deberías ver el prompt de MongoDB
# Salir con: exit
```

### 1.3 Crear Usuario de Prueba

```javascript
// Conectar a MongoDB
mongosh

// Usar la base de datos
use styleme_db

// Crear usuario
db.usuarios.insertOne({
  nombre: "Usuario Test",
  correo: "test@example.com",
  preferencias_color: ["azul", "negro"],
  preferencias_tipo: ["casual"],
  preferencias_temporada: ["verano"],
  guardarropa: [],
  outfits_generados: []
})

// Verificar que se creó
db.usuarios.findOne({correo: "test@example.com"})

// Salir
exit
```

---

## 🖥️ Paso 2: Iniciar el Servidor

```powershell
# Asegúrate de estar en el directorio styleme_back
cd styleme_back

# Iniciar servidor Django
python manage.py runserver
```

**Salida esperada:**
```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
October 08, 2025 - 21:00:00
Django version 5.2.4, using settings 'backend.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
```

✅ **Si ves esto, el servidor está corriendo correctamente**

❌ **Si hay errores:**
- Verificar que MongoDB esté corriendo
- Verificar que el puerto 8000 no esté ocupado
- Revisar logs en `logs/django.log`

---

## 🧪 Paso 3: Probar con Script Python (RECOMENDADO)

### Opción A: Script Automático

**Abre una NUEVA terminal** (deja el servidor corriendo) y ejecuta:

```powershell
# Activar entorno virtual
.\env\Scripts\activate

# Ejecutar script de prueba
python test_carga_imagenes.py
```

El script buscará automáticamente imágenes de prueba y probará el endpoint.

---

## 📸 Paso 4: Preparar Imagen de Prueba

Si no tienes imágenes, descarga una de prueba:

**Imágenes recomendadas:**
- Una foto de una camiseta
- Una foto de un pantalón
- Una foto con múltiples prendas

**Formatos aceptados:** JPG, PNG  
**Tamaño máximo:** 10 MB

---

## 🔧 Paso 5: Probar con cURL

### 5.1 Una Imagen

```powershell
# Reemplaza "foto.jpg" con tu imagen
curl -X POST http://localhost:8000/api/detect-clothing/ `
  -F "email=test@example.com" `
  -F "image=@foto.jpg"
```

### 5.2 Respuesta Exitosa Esperada

```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente. Se procesaron 1 de 1 imagen(es)",
  "total_images": 1,
  "processed_images": 1,
  "total_prendas_detectadas": 1,
  "prendas": [
    {
      "tipo": "camiseta",
      "color": "desconocido",
      "temporada": "desconocido",
      "imagen_id": "670abc123...",
      "imagen_url": "/api/images/670abc123...",
      "fecha_agregada": "2025-10-08T...",
      "confianza": "0.85"
    }
  ]
}
```

✅ **Si recibes esto, ¡el endpoint funciona!**

### 5.3 Múltiples Imágenes

```powershell
curl -X POST http://localhost:8000/api/detect-clothing/ `
  -F "email=test@example.com" `
  -F "images=@foto1.jpg" `
  -F "images=@foto2.jpg" `
  -F "images=@foto3.jpg"
```

---

## 🔍 Paso 6: Verificar en MongoDB

```javascript
// Conectar
mongosh
use styleme_db

// Ver usuario con prendas guardadas
db.usuarios.findOne({correo: "test@example.com"})

// Deberías ver el array "guardarropa" con las prendas detectadas

// Ver imágenes en GridFS
db.fs.files.find({"metadata.user_email": "test@example.com"}).pretty()

// Contar imágenes
db.fs.files.countDocuments({"metadata.user_email": "test@example.com"})
```

**Verificaciones:**
- [x] Usuario tiene prendas en `guardarropa`
- [x] Cada prenda tiene `imagen_id` y `imagen_url`
- [x] GridFS tiene archivos con metadata del usuario
- [x] El `length` en GridFS corresponde al tamaño de la imagen

---

## 🌐 Paso 7: Verificar Imagen en Navegador

### 7.1 Obtener URL de la Imagen

De la respuesta del paso 5, copia el `imagen_url`, por ejemplo:
```
/api/images/670abc123def456789
```

### 7.2 Abrir en Navegador

```
http://localhost:8000/api/images/670abc123def456789
```

✅ **Deberías ver la imagen cargada**

### 7.3 Ver Metadata

```
http://localhost:8000/api/images/670abc123def456789/metadata
```

**Respuesta esperada:**
```json
{
  "success": true,
  "metadata": {
    "file_id": "670abc123def456789",
    "filename": "test@example.com_uuid.jpg",
    "content_type": "image/jpeg",
    "length": 245678,
    "upload_date": "2025-10-08T...",
    "user_email": "test@example.com",
    "original_filename": "foto.jpg"
  }
}
```

---

## 🐛 Paso 8: Verificar Logs

```powershell
# Ver logs en tiempo real (nueva terminal)
Get-Content logs\django.log -Wait
```

**Busca líneas como:**
```
INFO ... Detectando prendas en imagen...
INFO ... Prendas detectadas: ['camiseta']
INFO ... Subiendo imagen a GridFS...
INFO ... Imagen subida exitosamente. ID: 670abc...
```

✅ **Si ves estos logs, todo está funcionando correctamente**

---

## ✅ Checklist de Verificación

Marca cada item cuando lo hayas verificado:

### Funcionalidad Básica
- [ ] Servidor Django inicia sin errores
- [ ] MongoDB está conectado
- [ ] Usuario de prueba existe en DB

### Carga de Imágenes
- [ ] Endpoint acepta una imagen
- [ ] Endpoint acepta múltiples imágenes
- [ ] Respuesta HTTP 200 OK
- [ ] Respuesta JSON válida con `success: true`

### Detección YOLO
- [ ] Se detectan prendas automáticamente
- [ ] Campo `tipo` tiene valor correcto
- [ ] Campo `confianza` está presente
- [ ] Tipos detectados: camiseta, pantalón, etc.

### Almacenamiento GridFS
- [ ] Imagen se guarda en GridFS
- [ ] `fs.files` contiene metadata
- [ ] `fs.chunks` contiene datos binarios
- [ ] `imagen_id` es un ObjectId válido

### Base de Datos
- [ ] Usuario tiene prendas en `guardarropa`
- [ ] Cada prenda tiene `imagen_id`
- [ ] Cada prenda tiene `imagen_url`
- [ ] Fecha de agregación está presente

### Servir Imágenes
- [ ] URL `/api/images/{id}` devuelve imagen
- [ ] URL `/api/images/{id}/metadata` devuelve JSON
- [ ] Imagen se visualiza correctamente en navegador
- [ ] Content-Type es correcto (image/jpeg o image/png)

### Validaciones
- [ ] Rechaza formatos inválidos (GIF, PDF, etc.)
- [ ] Rechaza imágenes muy grandes (>10 MB)
- [ ] Error si falta email
- [ ] Error si falta imagen
- [ ] Error si usuario no existe

### Logs y Errores
- [ ] Logs se escriben correctamente
- [ ] Errores se manejan apropiadamente
- [ ] Mensajes de error son descriptivos
- [ ] No hay stack traces en respuestas

---

## 🚨 Problemas Comunes

### 1. "Usuario no encontrado"

**Solución:**
```javascript
mongosh
use styleme_db
db.usuarios.insertOne({
  nombre: "Usuario Test",
  correo: "test@example.com",
  preferencias_color: [],
  preferencias_tipo: [],
  preferencias_temporada: [],
  guardarropa: [],
  outfits_generados: []
})
```

### 2. "No se detectaron prendas"

**Causas posibles:**
- Imagen no contiene prendas claras
- YOLO no reconoce el objeto
- Confianza muy baja (<0.5)

**Solución:**
- Usar imágenes con prendas visibles y centradas
- Fondo simple y buena iluminación

### 3. "Error al subir a MongoDB"

**Solución:**
```powershell
# Verificar que MongoDB esté corriendo
net start MongoDB

# Verificar conexión
mongosh
use styleme_db
db.runCommand({ping: 1})
```

### 4. Puerto 8000 ocupado

**Solución:**
```powershell
# Usar otro puerto
python manage.py runserver 8001

# Actualizar URL en pruebas:
http://localhost:8001/api/detect-clothing/
```

### 5. Modelo YOLO no descarga

**Solución:**
```powershell
# Descargar manualmente
cd recommendations\ia\models

# El modelo se descargará automáticamente en la primera ejecución
# Si falla, verificar conexión a internet
```

---

## 📊 Pruebas Avanzadas

### Prueba de Estrés: Múltiples Usuarios

```powershell
# Crear varios usuarios
mongosh
use styleme_db

db.usuarios.insertMany([
  {correo: "user1@test.com", nombre: "User 1", guardarropa: [], outfits_generados: []},
  {correo: "user2@test.com", nombre: "User 2", guardarropa: [], outfits_generados: []},
  {correo: "user3@test.com", nombre: "User 3", guardarropa: [], outfits_generados: []}
])
```

```powershell
# Subir imágenes para cada usuario
curl -X POST http://localhost:8000/api/detect-clothing/ -F "email=user1@test.com" -F "image=@foto1.jpg"
curl -X POST http://localhost:8000/api/detect-clothing/ -F "email=user2@test.com" -F "image=@foto2.jpg"
curl -X POST http://localhost:8000/api/detect-clothing/ -F "email=user3@test.com" -F "image=@foto3.jpg"
```

### Prueba de Validación: Casos de Error

```powershell
# 1. Sin email
curl -X POST http://localhost:8000/api/detect-clothing/ -F "image=@foto.jpg"
# Esperado: {"success": false, "error": "Email es requerido"}

# 2. Sin imagen
curl -X POST http://localhost:8000/api/detect-clothing/ -F "email=test@example.com"
# Esperado: {"success": false, "error": "No se proporcionó ninguna imagen"}

# 3. Formato inválido (si tienes un PDF o GIF)
curl -X POST http://localhost:8000/api/detect-clothing/ -F "email=test@example.com" -F "image=@documento.pdf"
# Esperado: {"success": false, "error": "Formato no válido..."}
```

---

## 📈 Métricas de Éxito

Después de todas las pruebas, verifica estas métricas:

```javascript
mongosh
use styleme_db

// Total de usuarios con prendas
db.usuarios.countDocuments({guardarropa: {$ne: []}})

// Total de imágenes en GridFS
db.fs.files.countDocuments()

// Tamaño total de imágenes (bytes)
db.fs.files.aggregate([
  {$group: {_id: null, total: {$sum: "$length"}}}
])

// Prendas por usuario
db.usuarios.aggregate([
  {$project: {correo: 1, num_prendas: {$size: "$guardarropa"}}}
])
```

---

## ✅ Confirmación Final

Si has completado todos los pasos y:

- ✅ El servidor inicia correctamente
- ✅ Las imágenes se cargan sin errores
- ✅ YOLO detecta prendas automáticamente
- ✅ Las imágenes se guardan en GridFS
- ✅ Las prendas aparecen en el guardarropa del usuario
- ✅ Las imágenes se sirven correctamente
- ✅ Las validaciones funcionan
- ✅ Los logs se escriben sin errores

**🎉 ¡El backend está listo para integrarse con el frontend!**

---

## 🚀 Próximos Pasos

1. **Documentar resultados** de las pruebas
2. **Compartir con el equipo** de frontend:
   - URL del endpoint
   - Ejemplos de request/response
   - Posibles errores
3. **Preparar ambiente de desarrollo** compartido
4. **Iniciar desarrollo del frontend** Flutter

---

## 📞 Contacto y Soporte

Si encuentras problemas:

1. **Revisar logs:** `logs/django.log`
2. **Consultar documentación:** `API_CARGA_IMAGENES.md`
3. **Ver arquitectura:** `ARQUITECTURA_MODULAR.md`
4. **Comandos útiles:** `COMANDOS_UTILES.md`

---

**Última actualización:** 08 de Octubre, 2025  
**Versión:** 1.0  
**Estado:** ✅ Listo para producción en desarrollo
