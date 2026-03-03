# 📱 StyleMe - Aplicación de Recomendación de Outfits con IA

**Tu estilo, tus reglas, crea tu outfit perfecto**

---

## 🎯 ¿Qué es StyleMe?

StyleMe es una aplicación móvil que utiliza **Inteligencia Artificial** para ayudarte a:

- 📸 **Capturar** tus prendas de ropa con la cámara
- 🤖 **Detectar** automáticamente el tipo de prenda usando YOLO
- 👔 **Organizar** tu guardarropa digital
- ✨ **Recibir** recomendaciones personalizadas de outfits

---

## 🚀 Inicio Rápido

### Opción 1: Ejecutar con Script (Más Fácil)

```powershell
# Doble click en:
EJECUTAR_PROYECTO.bat

# Seleccionar opción 3 (Ejecutar ambos)
```

### Opción 2: Manual

**Terminal 1 - Backend:**
```powershell
cd styleme_back
.\env\Scripts\activate
net start MongoDB
python crear_usuario_prueba.py  # Primera vez
python manage.py runserver
```

**Terminal 2 - Frontend:**
```powershell
cd styleme_front
flutter pub get
flutter run -d chrome
```

---

## 📋 Requisitos

### Backend
- Python 3.8+
- MongoDB 4.0+
- Entorno virtual

### Frontend
- Flutter 3.5.3+
- Chrome / Android Studio
- Emulador o dispositivo

---

## 🏗️ Arquitectura

```
Frontend (Flutter)  →  Backend (Django)  →  MongoDB + GridFS
     ↓                      ↓                      ↓
  10 Pantallas         API REST              Base de Datos
  7 Widgets            YOLO AI               Imágenes
  Provider             KMeans                
```

---

## 📱 Pantallas

1. **Splash** - Bienvenida
2. **Onboarding** - Tutorial (3 páginas)
3. **Login** - Inicio de sesión
4. **Registro** - Crear cuenta
5. **Configurar Perfil** - Preferencias (3 pasos)
6. **Home** - Navegación principal
7. **Recomendaciones** - Outfits sugeridos
8. **Guardarropa** - Todas tus prendas
9. **Cámara** - Capturar y detectar
10. **Perfil** - Tu información

---

## 🎨 Colores

```
Gradiente Auth:  #AF9338 → #E35B18
Botones:         #FFA75D
Header/Navbar:   #ECECEC
Fondo:           #F5F5F5
```

---

## 🔗 Endpoints API

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/api/detect-clothing/` | POST | Detectar prendas |
| `/api/recommend/` | POST | Generar outfits |
| `/api/images/<id>` | GET | Obtener imagen |

---

## 📚 Documentación

### Guías Principales
- 📖 **[GUIA_COMPLETA_EJECUCION.md](GUIA_COMPLETA_EJECUCION.md)** - Guía paso a paso completa
- 📊 **[RESUMEN_FINAL.md](RESUMEN_FINAL.md)** - Resumen del proyecto

### Backend
- 🏗️ **[styleme_back/ARQUITECTURA_MODULAR.md](styleme_back/ARQUITECTURA_MODULAR.md)** - Arquitectura
- 🔌 **[styleme_back/API_CARGA_IMAGENES.md](styleme_back/API_CARGA_IMAGENES.md)** - API
- ⚡ **[styleme_back/VERIFICACION_RAPIDA.md](styleme_back/VERIFICACION_RAPIDA.md)** - Inicio rápido

### Frontend
- 📱 **[styleme_front/INSTRUCCIONES.md](styleme_front/INSTRUCCIONES.md)** - Instalación
- 📝 **[styleme_front/RESUMEN_IMPLEMENTACION.md](styleme_front/RESUMEN_IMPLEMENTACION.md)** - Estado
- ⚡ **[styleme_front/INICIO_RAPIDO.md](styleme_front/INICIO_RAPIDO.md)** - Inicio rápido

---

## 🧪 Probar el Proyecto

### 1. Crear Usuario
```powershell
cd styleme_back
python crear_usuario_prueba.py
```

### 2. Probar con Postman
```powershell
# Importar colección:
styleme_back/StyleMe_Postman_Collection.json
```

### 3. Usar la App
1. Login con: `test@example.com`
2. Configurar preferencias
3. Ir a Cámara
4. Seleccionar imagen
5. Detectar prenda
6. Ver en Guardarropa
7. Generar outfit

---

## 🛠️ Tecnologías

### Backend
- Django 5.2.4
- MongoDB + GridFS
- YOLOv8 (Ultralytics)
- KMeans (scikit-learn)
- PyTorch, OpenCV

### Frontend
- Flutter 3.5.3+
- Provider (State Management)
- HTTP/Dio (API)
- Image Picker (Cámara)
- Cached Network Image

---

## 📊 Estadísticas

- **Líneas de código:** ~6,500
- **Archivos creados:** 75+
- **Pantallas:** 10
- **Widgets:** 7
- **Endpoints:** 5
- **Documentación:** 15+ archivos

---

## ✅ Estado del Proyecto

| Componente | Estado | Progreso |
|------------|--------|----------|
| Backend | ✅ Completo | 100% |
| Frontend | ✅ Completo | 100% |
| Integración | ✅ Funcional | 100% |
| Documentación | ✅ Completa | 100% |
| **TOTAL** | **✅ LISTO** | **100%** |

---

## 🎯 Funcionalidades Principales

✅ Detección automática de prendas con IA  
✅ Guardarropa digital organizado  
✅ Filtros por tipo, color, temporada  
✅ Recomendaciones personalizadas  
✅ Carrusel de outfits  
✅ Perfil de usuario  
✅ Configuración de preferencias  
✅ Almacenamiento en la nube  

---

## 🐛 Solución de Problemas

### Backend no inicia
```powershell
net start MongoDB
cd styleme_back
.\env\Scripts\activate
python manage.py runserver
```

### Frontend no compila
```powershell
cd styleme_front
flutter clean
flutter pub get
flutter run -d chrome
```

### No detecta prendas
- Verificar que backend esté corriendo
- Verificar URL en `app_constants.dart`
- Usar imágenes claras de prendas

---

## 📞 Soporte

**Documentación completa:** Ver carpetas `styleme_back/` y `styleme_front/`  
**Guía de ejecución:** `GUIA_COMPLETA_EJECUCION.md`  
**Resumen final:** `RESUMEN_FINAL.md`

---

## 👥 Equipo

**Frontend:** Persona 1 y Persona 2  
**Backend:** Persona 3  
**Proyecto:** Investigación III - 9° Semestre 2025-2

---

## 📄 Licencia

Proyecto académico - Universidad [Tu Universidad]

---

## 🎉 ¡Gracias!

**StyleMe** - Tu asistente personal de moda con IA

---

**Última actualización:** 12 de Octubre, 2025  
**Versión:** 1.0.0  
**Estado:** ✅ Completado y Funcional
