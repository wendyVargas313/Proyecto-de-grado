# 🛠️ Comandos Útiles - StyleMe Backend

Referencia rápida de comandos para desarrollo.

---

## 🚀 Inicio Rápido

### Activar Entorno Virtual

```bash
# Windows
env\Scripts\activate

# Linux/Mac
source env/bin/activate
```

### Ejecutar Servidor

```bash
python manage.py runserver

# En otro puerto
python manage.py runserver 8001
```

### Verificar Instalación

```bash
python verificar_instalacion.py
```

---

## 📦 Gestión de Dependencias

### Instalar Dependencias

```bash
pip install -r requirements.txt
```

### Actualizar Dependencias

```bash
pip install --upgrade -r requirements.txt
```

### Ver Dependencias Instaladas

```bash
pip list
```

### Agregar Nueva Dependencia

```bash
pip install nombre-paquete
pip freeze > requirements.txt
```

---

## 🗄️ MongoDB

### Iniciar MongoDB

```bash
# Windows
net start MongoDB

# Linux
sudo systemctl start mongod

# Mac
brew services start mongodb-community
```

### Detener MongoDB

```bash
# Windows
net stop MongoDB

# Linux
sudo systemctl stop mongod

# Mac
brew services stop mongodb-community
```

### Conectar a MongoDB

```bash
mongo

# O con mongosh (versión nueva)
mongosh
```

### Comandos MongoDB Útiles

```javascript
// Ver bases de datos
show dbs

// Usar base de datos
use styleme_db

// Ver colecciones
show collections

// Ver usuarios
db.usuarios.find().pretty()

// Contar usuarios
db.usuarios.count()

// Ver imágenes en GridFS
db.fs.files.find().pretty()

// Contar imágenes
db.fs.files.count()

// Ver imágenes de un usuario
db.fs.files.find({"metadata.user_email": "test@example.com"})

// Eliminar todas las imágenes
db.fs.files.deleteMany({})
db.fs.chunks.deleteMany({})

// Eliminar un usuario
db.usuarios.deleteOne({correo: "test@example.com"})

// Crear usuario de prueba
db.usuarios.insertOne({
  nombre: "Usuario Test",
  correo: "test@example.com",
  preferencias_color: ["azul", "negro"],
  preferencias_tipo: ["casual"],
  preferencias_temporada: ["verano"],
  guardarropa: [],
  outfits_generados: []
})
```

---

## 🧪 Probar Endpoints

### Detectar Prendas

```bash
# Una imagen
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=test@example.com" \
  -F "image=@foto.jpg"

# Múltiples imágenes
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=test@example.com" \
  -F "images=@foto1.jpg" \
  -F "images=@foto2.jpg" \
  -F "images=@foto3.jpg"
```

### Generar Outfits

```bash
curl -X POST http://localhost:8000/api/recommend/ \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com"}'
```

### Predecir con IA

```bash
curl -X POST http://localhost:8000/api/recommend-outfit-ai/ \
  -H "Content-Type: application/json" \
  -d '{
    "tipo_camiseta": 1,
    "tipo_jeans": 1,
    "color_azul": 1,
    "temporada_verano": 1
  }'
```

### Obtener Imagen

```bash
# Ver en navegador
http://localhost:8000/api/images/67054abc123def456789

# Descargar
curl http://localhost:8000/api/images/67054abc123def456789 > imagen.jpg

# Ver metadata
curl http://localhost:8000/api/images/67054abc123def456789/metadata
```

---

## 🐍 Django Management

### Migraciones

```bash
# Crear migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Ver migraciones
python manage.py showmigrations
```

### Shell Interactivo

```bash
# Shell de Django
python manage.py shell

# Shell de Python
python
```

### Crear Superusuario

```bash
python manage.py createsuperuser
```

### Recolectar Archivos Estáticos

```bash
python manage.py collectstatic
```

---

## 📝 Logs

### Ver Logs en Tiempo Real

```bash
# Windows (PowerShell)
Get-Content logs\django.log -Wait

# Linux/Mac
tail -f logs/django.log
```

### Limpiar Logs

```bash
# Windows
del logs\django.log

# Linux/Mac
rm logs/django.log
```

---

## 🧹 Limpieza

### Limpiar Archivos Temporales

```bash
# Windows
rmdir /s /q recommendations\media\temp

# Linux/Mac
rm -rf recommendations/media/temp
```

### Limpiar __pycache__

```bash
# Windows
for /d /r . %d in (__pycache__) do @if exist "%d" rd /s /q "%d"

# Linux/Mac
find . -type d -name __pycache__ -exec rm -rf {} +
```

### Limpiar Base de Datos de Prueba

```javascript
use styleme_db

// Eliminar todos los usuarios
db.usuarios.deleteMany({})

// Eliminar todas las imágenes
db.fs.files.deleteMany({})
db.fs.chunks.deleteMany({})
```

---

## 🔍 Debugging

### Ejecutar con Debug

```bash
python manage.py runserver --settings=backend.settings_debug
```

### Ver Variables de Entorno

```bash
# Windows
set

# Linux/Mac
env
```

### Verificar Puerto Ocupado

```bash
# Windows
netstat -ano | findstr :8000

# Linux/Mac
lsof -i :8000
```

### Matar Proceso en Puerto

```bash
# Windows
taskkill /PID <PID> /F

# Linux/Mac
kill -9 <PID>
```

---

## 📊 Estadísticas

### Contar Líneas de Código

```bash
# Windows (PowerShell)
(Get-ChildItem -Recurse -Include *.py | Get-Content | Measure-Object -Line).Lines

# Linux/Mac
find . -name "*.py" | xargs wc -l
```

### Ver Tamaño de Base de Datos

```javascript
use styleme_db
db.stats()
```

### Ver Tamaño de GridFS

```javascript
use styleme_db

// Tamaño total de imágenes
db.fs.files.aggregate([
  {$group: {_id: null, total: {$sum: "$length"}}}
])

// Imágenes por usuario
db.fs.files.aggregate([
  {$group: {_id: "$metadata.user_email", count: {$sum: 1}}}
])
```

---

## 🧪 Testing

### Ejecutar Tests

```bash
python manage.py test
```

### Ejecutar Tests con Coverage

```bash
pip install coverage
coverage run --source='.' manage.py test
coverage report
coverage html
```

---

## 📦 Git

### Comandos Básicos

```bash
# Ver estado
git status

# Agregar archivos
git add .

# Commit
git commit -m "Mensaje descriptivo"

# Push
git push origin main

# Pull
git pull origin main

# Ver branches
git branch

# Crear branch
git checkout -b feature/nueva-funcionalidad

# Cambiar branch
git checkout main
```

### Ver Cambios

```bash
# Ver diferencias
git diff

# Ver log
git log --oneline --graph

# Ver archivos modificados
git diff --name-only
```

---

## 🔧 Configuración

### Variables de Entorno

```bash
# Windows
set MONGO_HOST=localhost
set MONGO_PORT=27017
set MONGO_DB=styleme_db

# Linux/Mac
export MONGO_HOST=localhost
export MONGO_PORT=27017
export MONGO_DB=styleme_db
```

### Archivo .env (Opcional)

```bash
# Crear archivo .env
echo "MONGO_HOST=localhost" > .env
echo "MONGO_PORT=27017" >> .env
echo "MONGO_DB=styleme_db" >> .env

# Instalar python-decouple
pip install python-decouple
```

---

## 🚨 Solución Rápida de Problemas

### MongoDB no conecta

```bash
# 1. Verificar que esté corriendo
mongo

# 2. Si no funciona, iniciar
net start MongoDB  # Windows
sudo systemctl start mongod  # Linux

# 3. Verificar puerto
netstat -an | findstr :27017
```

### Puerto 8000 ocupado

```bash
# Usar otro puerto
python manage.py runserver 8001
```

### Error de importación

```bash
# Reinstalar dependencias
pip install -r requirements.txt --force-reinstall
```

### GridFS no funciona

```bash
# Verificar pymongo
pip install --upgrade pymongo

# Verificar MongoDB
mongo
> use styleme_db
> db.fs.files.find()
```

---

## 📚 Recursos Útiles

### Documentación

```bash
# Ver documentación local
start ARQUITECTURA_MODULAR.md  # Windows
open ARQUITECTURA_MODULAR.md   # Mac
xdg-open ARQUITECTURA_MODULAR.md  # Linux
```

### URLs Importantes

- Admin: http://localhost:8000/admin/
- API Root: http://localhost:8000/api/
- Detect Clothing: http://localhost:8000/api/detect-clothing/
- Recommend: http://localhost:8000/api/recommend/

---

## 💡 Tips

1. **Siempre activar el entorno virtual** antes de trabajar
2. **Verificar que MongoDB esté corriendo** antes de ejecutar el servidor
3. **Hacer commits frecuentes** con mensajes descriptivos
4. **Revisar logs** cuando algo no funcione
5. **Usar el script de verificación** después de cambios importantes

---

**Última actualización:** 08 de Octubre, 2025
