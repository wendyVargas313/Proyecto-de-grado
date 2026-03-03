# 🚀 Guía de Instalación - StyleMe Backend

Guía paso a paso para configurar y ejecutar el backend de StyleMe.

---

## 📋 Requisitos Previos

- Python 3.8 o superior
- MongoDB instalado y corriendo (puerto 27017)
- Git

---

## 🔧 Instalación

### 1. Clonar el Repositorio

```bash
git clone <url-del-repositorio>
cd styleme_back
```

### 2. Crear Entorno Virtual

**Windows:**
```bash
python -m venv env
env\Scripts\activate
```

**Linux/Mac:**
```bash
python3 -m venv env
source env/bin/activate
```

### 3. Instalar Dependencias

```bash
pip install -r requirements.txt
```

Esto instalará:
- Django 5.2.4
- Django REST Framework
- MongoDB (mongoengine, pymongo, gridfs)
- YOLO (ultralytics)
- PyTorch
- OpenCV
- scikit-learn
- Y más...

### 4. Configurar MongoDB

Asegúrate de que MongoDB esté corriendo:

```bash
# Windows
net start MongoDB

# Linux/Mac
sudo systemctl start mongod
```

Verifica la conexión:
```bash
mongo
> show dbs
> exit
```

### 5. Aplicar Migraciones de Django

```bash
python manage.py migrate
```

### 6. Crear Superusuario (Opcional)

```bash
python manage.py createsuperuser
```

---

## ▶️ Ejecutar el Servidor

### Modo Desarrollo

```bash
python manage.py runserver
```

El servidor estará disponible en: `http://localhost:8000`

### Verificar que funciona

Abre en el navegador:
- Admin: `http://localhost:8000/admin/`
- API: `http://localhost:8000/api/`

---

## 🧪 Probar el API

### 1. Crear un Usuario de Prueba

Abre MongoDB Compass o la terminal de mongo:

```javascript
use styleme_db

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

### 2. Probar Endpoint de Carga de Imágenes

```bash
curl -X POST http://localhost:8000/api/detect-clothing/ \
  -F "email=test@example.com" \
  -F "image=@ruta/a/tu/imagen.jpg"
```

### 3. Probar Endpoint de Recomendaciones

```bash
curl -X POST http://localhost:8000/api/recommend/ \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com"}'
```

---

## 📁 Estructura del Proyecto

```
styleme_back/
├── backend/                    # Configuración de Django
│   ├── settings.py            # Configuración principal
│   ├── urls.py                # URLs principales
│   └── wsgi.py
│
├── recommendations/            # App principal
│   ├── controllers/           # Endpoints HTTP
│   │   ├── outfit_controller.py
│   │   └── imagen_controller.py
│   │
│   ├── services/              # Lógica de negocio
│   │   ├── outfit_service.py
│   │   ├── imagen_service.py
│   │   ├── user_service.py
│   │   └── gridfs_service.py
│   │
│   ├── repository/            # Acceso a datos
│   │   ├── user_repository.py
│   │   └── outfit_repository.py
│   │
│   ├── dto/                   # Data Transfer Objects
│   │   ├── clothing_dto.py
│   │   ├── outfit_dto.py
│   │   └── user_dto.py
│   │
│   ├── entity/                # Modelos de MongoDB
│   │   ├── user.py
│   │   ├── clothing.py
│   │   └── outfit.py
│   │
│   ├── ia/                    # Módulos de IA
│   │   ├── detector.py        # YOLO
│   │   ├── recommender.py     # KMeans
│   │   └── models/            # Modelos entrenados
│   │
│   └── urls.py                # URLs de la app
│
├── requirements.txt           # Dependencias
├── manage.py                  # CLI de Django
├── db.sqlite3                 # BD de Django
│
└── Documentación/
    ├── ARQUITECTURA_MODULAR.md
    ├── MONGODB_GRIDFS_SETUP.md
    ├── API_CARGA_IMAGENES.md
    └── README_INSTALACION.md (este archivo)
```

---

## 🌐 Endpoints Disponibles

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/detect-clothing/` | Detecta y guarda prendas desde imágenes |
| POST | `/api/recommend/` | Genera recomendaciones de outfits |
| POST | `/api/recommend-outfit-ai/` | Predice grupo de outfit con IA |
| GET | `/api/images/{file_id}` | Sirve imagen desde GridFS |
| GET | `/api/images/{file_id}/metadata` | Obtiene metadata de imagen |
| GET | `/admin/` | Panel de administración de Django |

Ver documentación completa en [API_CARGA_IMAGENES.md](./API_CARGA_IMAGENES.md)

---

## 🔍 Verificar Instalación

### Checklist

- [ ] Python 3.8+ instalado
- [ ] Entorno virtual creado y activado
- [ ] Dependencias instaladas (`pip list`)
- [ ] MongoDB corriendo (`mongo` funciona)
- [ ] GridFS inicializado
- [ ] Migraciones aplicadas
- [ ] Servidor Django corre sin errores
- [ ] Endpoint de prueba responde

### Script de Verificación

Crea un archivo `verify_setup.py`:

```python
import sys
import os

def verify_setup():
    print("🔍 Verificando instalación...\n")
    
    # 1. Python version
    print(f"✓ Python: {sys.version}")
    
    # 2. Django
    try:
        import django
        print(f"✓ Django: {django.get_version()}")
    except ImportError:
        print("✗ Django no instalado")
        return False
    
    # 3. MongoDB
    try:
        from mongoengine import connect
        connect('test_db', host='localhost', port=27017)
        print("✓ MongoDB: Conectado")
    except Exception as e:
        print(f"✗ MongoDB: Error - {e}")
        return False
    
    # 4. GridFS
    try:
        from recommendations.services.gridfs_service import GridFSService
        GridFSService.initialize()
        print("✓ GridFS: Inicializado")
    except Exception as e:
        print(f"✗ GridFS: Error - {e}")
        return False
    
    # 5. YOLO
    try:
        from ultralytics import YOLO
        print("✓ YOLO: Instalado")
    except ImportError:
        print("✗ YOLO no instalado")
        return False
    
    # 6. PyTorch
    try:
        import torch
        print(f"✓ PyTorch: {torch.__version__}")
    except ImportError:
        print("✗ PyTorch no instalado")
        return False
    
    print("\n✅ Instalación verificada correctamente")
    return True

if __name__ == "__main__":
    verify_setup()
```

Ejecuta:
```bash
python verify_setup.py
```

---

## 🐛 Solución de Problemas

### Error: "No module named 'mongoengine'"

```bash
pip install mongoengine pymongo
```

### Error: "Connection refused" (MongoDB)

Inicia MongoDB:
```bash
# Windows
net start MongoDB

# Linux
sudo systemctl start mongod
```

### Error: "GridFS initialization failed"

Verifica que MongoDB esté corriendo y accesible en localhost:27017

### Error: "YOLO model not found"

Asegúrate de que el modelo esté en:
```
recommendations/ia/models/yolov8n.pt
```

Si no existe, se descargará automáticamente la primera vez.

### Error: "Port 8000 already in use"

```bash
# Usar otro puerto
python manage.py runserver 8001

# O matar el proceso en el puerto 8000
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8000 | xargs kill -9
```

---

## 📊 Variables de Entorno (Opcional)

Crea un archivo `.env` en la raíz:

```env
# Django
DEBUG=True
SECRET_KEY=tu-secret-key-aqui

# MongoDB
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_DB=styleme_db

# Firebase
FIREBASE_STORAGE_BUCKET=tu-proyecto.appspot.com

# Logging
LOG_LEVEL=DEBUG
```

Instala python-decouple:
```bash
pip install python-decouple
```

Actualiza `settings.py`:
```python
from decouple import config

DEBUG = config('DEBUG', default=True, cast=bool)
SECRET_KEY = config('SECRET_KEY', default='default-key')
```

---

## 🚀 Despliegue (Producción)

### Preparar para Producción

1. **Actualizar settings.py:**
```python
DEBUG = False
ALLOWED_HOSTS = ['tu-dominio.com', 'www.tu-dominio.com']
```

2. **Usar variables de entorno para secretos**

3. **Configurar servidor web (Nginx + Gunicorn)**

4. **Usar base de datos en la nube (MongoDB Atlas)**

5. **Configurar HTTPS**

---

## 📚 Documentación Adicional

- [ARQUITECTURA_MODULAR.md](./ARQUITECTURA_MODULAR.md) - Arquitectura del proyecto
- [MONGODB_GRIDFS_SETUP.md](./MONGODB_GRIDFS_SETUP.md) - Almacenamiento con GridFS
- [API_CARGA_IMAGENES.md](./API_CARGA_IMAGENES.md) - Documentación del API

---

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 📝 Licencia

Este proyecto es parte de un proyecto de grado universitario.

---

## 👥 Equipo

- Persona 1: Frontend - Gestión de Usuario e Imágenes
- Persona 2: Frontend - Visualización y Recomendaciones
- Persona 3: Backend - IA y Mejoras

---

**¿Problemas con la instalación?** Revisa los logs en `styleme_back/logs/django.log`
