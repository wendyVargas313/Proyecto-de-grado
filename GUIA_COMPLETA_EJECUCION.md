# 🚀 Guía Completa de Ejecución - StyleMe

**Proyecto completo: Backend + Frontend**  
**Fecha:** 12 de Octubre, 2025

---

## 📋 Requisitos Previos

### Backend
- ✅ Python 3.8+
- ✅ MongoDB 4.0+
- ✅ Entorno virtual de Python

### Frontend
- ✅ Flutter 3.5.3+
- ✅ Dart SDK
- ✅ Android Studio / VS Code
- ✅ Emulador Android o dispositivo físico

---

## 🎯 Paso 1: Configurar y Ejecutar el Backend

### 1.1 Navegar al directorio del backend

```powershell
cd styleme_back
```

### 1.2 Activar entorno virtual

```powershell
.\env\Scripts\activate
```

### 1.3 Instalar dependencias (si no lo has hecho)

```powershell
pip install -r requirements.txt
```

### 1.4 Iniciar MongoDB

```powershell
net start MongoDB
```

### 1.5 Crear usuario de prueba

```powershell
python crear_usuario_prueba.py
# Seleccionar opción 1
```

### 1.6 Iniciar servidor Django

```powershell
python manage.py runserver
```

**✅ El backend debería estar corriendo en:** `http://localhost:8000`

---

## 📱 Paso 2: Configurar y Ejecutar el Frontend

### 2.1 Abrir NUEVA terminal (dejar el backend corriendo)

```powershell
# Nueva terminal PowerShell
```

### 2.2 Navegar al directorio del frontend

```powershell
cd styleme_front
```

### 2.3 Instalar dependencias

```powershell
flutter pub get
```

**Salida esperada:**
```
Running "flutter pub get" in styleme_front...
Resolving dependencies...
Got dependencies!
```

### 2.4 Verificar dispositivos disponibles

```powershell
flutter devices
```

**Opciones:**
- Chrome (Web)
- Windows (Desktop)
- Emulador Android
- Dispositivo físico

### 2.5 Ejecutar la aplicación

```powershell
# Opción 1: Chrome (más rápido para desarrollo)
flutter run -d chrome

# Opción 2: Windows
flutter run -d windows

# Opción 3: Android
flutter run -d emulator-5554
```

**✅ La app debería iniciarse automáticamente**

---

## 🎨 Flujo de la Aplicación

### 1. **Splash Screen** (3 segundos)
- Logo STYLEME
- Slogan: "Tu estilo, tus reglas, crea tu outfit perfecto"
- Gradiente naranja (#AF9338 → #E35B18)

### 2. **Onboarding** (3 páginas)
- Página 1: "Diseña tu atuendo perfecto en segundos"
- Página 2: "Captura tus prendas fácilmente"
- Página 3: "Recibe recomendaciones personalizadas"
- Botón "Comenzar"

### 3. **Login**
- Email: `test@example.com`
- Contraseña: cualquiera (por ahora no valida)
- Link a "Regístrate"

### 4. **Registro** (opcional)
- Nombre, Email, Contraseña, Confirmar contraseña
- Botón "Registrarse"

### 5. **Configurar Perfil** (3 pasos)
- **Paso 1:** Seleccionar tipos de prenda favoritos
- **Paso 2:** Seleccionar colores favoritos
- **Paso 3:** Seleccionar temporadas favoritas
- Botón "Finalizar"

### 6. **Home** (Bottom Navigation)

#### Tab 1: **Inicio / Recomendaciones**
- Saludo: "¡Hola, Usuario!"
- Carrusel de outfits recomendados
- Botón "Generar nuevo outfit"

#### Tab 2: **Guardarropa**
- Grid de prendas (2 columnas)
- Filtros por tipo, color, temporada
- Botón de búsqueda

#### Tab 3: **Cámara** (botón central naranja)
- Opción: "Tomar foto"
- Opción: "Seleccionar de galería"
- Detección automática con IA
- Guardar en guardarropa

#### Tab 4: **Perfil**
- Foto de perfil
- Nombre y email
- Estadísticas (prendas, outfits)
- Preferencias
- Opciones
- Cerrar sesión

---

## 🧪 Probar la Integración Backend-Frontend

### Prueba 1: Agregar Prenda desde la Cámara

1. En la app, ir al tab **Cámara** (botón naranja central)
2. Click en "Seleccionar de galería"
3. Seleccionar una imagen de una prenda
4. Click en "Detectar"
5. ✅ Debería detectar la prenda y mostrar el tipo
6. La prenda se guarda automáticamente en el guardarropa

### Prueba 2: Ver Guardarropa

1. Ir al tab **Guardarropa**
2. ✅ Debería mostrar la prenda agregada
3. Probar filtros (tipo, color, temporada)

### Prueba 3: Generar Recomendaciones

1. Ir al tab **Inicio**
2. Click en "Generar nuevo outfit"
3. ✅ Debería generar combinaciones de prendas
4. Swipe para ver diferentes outfits

---

## 🐛 Solución de Problemas

### Backend

#### Error: "MongoDB no conecta"
```powershell
net start MongoDB
mongosh --eval "db.runCommand({ping: 1})"
```

#### Error: "Puerto 8000 ocupado"
```powershell
# Usar otro puerto
python manage.py runserver 8001

# Actualizar en frontend:
# lib/core/constants/app_constants.dart
# baseUrl = 'http://localhost:8001/api'
```

#### Error: "Usuario no encontrado"
```powershell
python crear_usuario_prueba.py
```

### Frontend

#### Error: "No devices found"
```powershell
# Ejecutar en Chrome
flutter run -d chrome
```

#### Error: "Pub get failed"
```powershell
flutter clean
flutter pub get
```

#### Error: "Connection refused" al detectar prendas

**Causa:** Backend no está corriendo o URL incorrecta

**Solución:**
1. Verificar que el backend esté corriendo en `http://localhost:8000`
2. Si usas dispositivo físico, cambiar URL en:
   ```dart
   // lib/core/constants/app_constants.dart
   static const String baseUrl = 'http://TU_IP:8000/api';
   // Ejemplo: 'http://192.168.1.100:8000/api'
   ```

#### Error: "Image picker not working"

**En Windows/Chrome:** Funciona con "Seleccionar de galería"  
**En Android:** Necesita permisos de cámara y almacenamiento

---

## 📊 Verificación Completa

### Checklist Backend
- [ ] MongoDB corriendo
- [ ] Servidor Django en puerto 8000
- [ ] Usuario de prueba creado
- [ ] Endpoint `/api/detect-clothing/` responde
- [ ] Logs sin errores

### Checklist Frontend
- [ ] `flutter pub get` exitoso
- [ ] App se ejecuta sin errores
- [ ] Navegación entre pantallas funciona
- [ ] Colores coinciden con diseño
- [ ] Formularios validan correctamente

### Checklist Integración
- [ ] Cámara puede seleccionar imágenes
- [ ] Detección de prendas funciona
- [ ] Prendas se guardan en guardarropa
- [ ] Imágenes se muestran desde backend
- [ ] Recomendaciones se generan

---

## 🎨 Colores del Diseño

Verificar que los colores se vean correctamente:

```
Gradiente Auth:  #AF9338 → #E35B18
Botones:         #FFA75D
Header/Navbar:   #ECECEC
Fondo:           #F5F5F5
```

---

## 📝 Comandos Útiles

### Backend
```powershell
# Ver logs en tiempo real
Get-Content logs\django.log -Wait

# Verificar MongoDB
mongosh
use styleme_db
db.usuarios.find().pretty()

# Reiniciar servidor
# Ctrl+C y luego:
python manage.py runserver
```

### Frontend
```powershell
# Hot reload (mientras corre)
# Presiona 'r' en la terminal

# Hot restart
# Presiona 'R' en la terminal

# Ver logs
flutter logs

# Analizar código
flutter analyze

# Formatear código
flutter format lib/
```

---

## 🎯 Próximos Pasos de Desarrollo

### Funcionalidades Pendientes

1. **Autenticación real**
   - Integrar con Firebase o backend propio
   - Validación de credenciales
   - Recuperación de contraseña

2. **Editar prendas**
   - Cambiar tipo, color, temporada manualmente
   - Eliminar prendas
   - Marcar favoritos

3. **Compartir outfits**
   - Generar imagen del outfit
   - Compartir en redes sociales

4. **Notificaciones**
   - Sugerencias diarias de outfits
   - Recordatorios

5. **Modo offline**
   - Caché de imágenes
   - Sincronización cuando hay conexión

---

## 📚 Estructura de Archivos

```
Proyecto de grado - desarrollo/
│
├── styleme_back/              # Backend Django
│   ├── recommendations/       # App principal
│   ├── backend/              # Configuración
│   ├── logs/                 # Logs del servidor
│   ├── manage.py
│   └── requirements.txt
│
├── styleme_front/            # Frontend Flutter
│   ├── lib/
│   │   ├── core/            # Constantes, colores
│   │   ├── models/          # Modelos de datos
│   │   ├── providers/       # Estado (Provider)
│   │   ├── services/        # API, Storage
│   │   ├── routes/          # Navegación
│   │   ├── ui/
│   │   │   ├── screens/     # Pantallas
│   │   │   └── widgets/     # Widgets reutilizables
│   │   └── main.dart
│   ├── assets/              # Imágenes, iconos
│   └── pubspec.yaml
│
└── GUIA_COMPLETA_EJECUCION.md  # Este archivo
```

---

## ✅ Estado del Proyecto

### Backend: ✅ 100% Funcional
- [x] API de detección de prendas
- [x] API de recomendaciones
- [x] Almacenamiento en MongoDB
- [x] GridFS para imágenes
- [x] Logs y validaciones

### Frontend: ✅ 90% Funcional
- [x] Splash, Onboarding, Login, Registro
- [x] Configuración de perfil (3 pasos)
- [x] Home con Bottom Navigation
- [x] Guardarropa con filtros
- [x] Cámara con detección IA
- [x] Recomendaciones con carrusel
- [x] Perfil con estadísticas
- [ ] Edición de prendas (pendiente)
- [ ] Compartir outfits (pendiente)

### Integración: ✅ 100% Funcional
- [x] Comunicación Backend-Frontend
- [x] Carga de imágenes
- [x] Detección con YOLO
- [x] Almacenamiento en MongoDB
- [x] Visualización de imágenes

---

## 🎉 ¡Listo para Usar!

Si seguiste todos los pasos, deberías tener:

1. ✅ Backend corriendo en `http://localhost:8000`
2. ✅ Frontend corriendo en tu dispositivo/emulador
3. ✅ Integración completa funcionando
4. ✅ Capacidad de agregar prendas con IA
5. ✅ Generación de recomendaciones de outfits

---

## 📞 Soporte

**Documentación adicional:**
- Backend: `styleme_back/GUIA_VERIFICACION_BACKEND.md`
- Frontend: `styleme_front/INSTRUCCIONES.md`
- Resumen: `styleme_front/RESUMEN_IMPLEMENTACION.md`

---

**¡Feliz desarrollo!** 🚀

**Última actualización:** 12 de Octubre, 2025  
**Versión:** 1.0.0
