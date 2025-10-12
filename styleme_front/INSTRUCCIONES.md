# 📱 StyleMe Frontend - Instrucciones de Instalación y Ejecución

**Fecha:** 12 de Octubre, 2025  
**Framework:** Flutter 3.5.3+

---

## 🚀 Inicio Rápido

### Paso 1: Instalar Dependencias

```bash
# Navegar al directorio del frontend
cd styleme_front

# Instalar dependencias
flutter pub get
```

### Paso 2: Verificar Instalación

```bash
# Verificar que Flutter esté correctamente instalado
flutter doctor

# Debería mostrar ✓ en Flutter, Android toolchain, y tu IDE
```

### Paso 3: Ejecutar la Aplicación

```bash
# Ejecutar en modo debug
flutter run

# O especificar dispositivo
flutter run -d chrome  # Para web
flutter run -d windows # Para Windows
```

---

## 📁 Estructura del Proyecto

```
styleme_front/
├── lib/
│   ├── core/
│   │   └── constants/
│   │       ├── app_colors.dart          # Colores de la app
│   │       ├── app_text_styles.dart     # Estilos de texto
│   │       └── app_constants.dart       # Constantes generales
│   │
│   ├── models/
│   │   └── user_model.dart              # Modelos de datos
│   │
│   ├── providers/
│   │   ├── user_provider.dart           # Estado del usuario
│   │   └── wardrobe_provider.dart       # Estado del guardarropa
│   │
│   ├── services/
│   │   ├── api_service.dart             # Comunicación con backend
│   │   └── storage_service.dart         # Almacenamiento local
│   │
│   ├── routes/
│   │   └── app_routes.dart              # Rutas de navegación
│   │
│   ├── ui/
│   │   ├── screens/                     # Pantallas
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   └── login_screen.dart
│   │   │
│   │   └── widgets/                     # Widgets reutilizables
│   │       ├── custom_button.dart
│   │       └── custom_text_field.dart
│   │
│   └── main.dart                        # Punto de entrada
│
├── assets/
│   ├── images/                          # Imágenes
│   └── icons/                           # Iconos
│
├── pubspec.yaml                         # Dependencias
└── INSTRUCCIONES.md                     # Este archivo
```

---

## 🎨 Colores de la Aplicación

Los colores están definidos en `lib/core/constants/app_colors.dart`:

```dart
// Autenticación
primaryOrange: #AF9338
secondaryOrange: #E35B18

// Botones
buttonOrange: #FFA75D

// UI
header: #ECECEC
background: #F5F5F5
```

---

## 📦 Dependencias Principales

```yaml
# State Management
provider: ^6.1.1

# HTTP & API
http: ^1.1.0
dio: ^5.4.0

# Image Handling
image_picker: ^1.0.5
cached_network_image: ^3.3.0
camera: ^0.10.5+7

# Storage
shared_preferences: ^2.2.2

# Navigation
go_router: ^12.1.3

# UI Components
smooth_page_indicator: ^1.1.0
flutter_svg: ^2.0.9
```

---

## 🔧 Configuración del Backend

El frontend se conecta al backend en:

```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://localhost:8000/api';
```

**Para cambiar la URL del backend:**

1. Abre `lib/core/constants/app_constants.dart`
2. Modifica `baseUrl` con la URL de tu backend
3. Ejemplo para dispositivo físico: `http://192.168.1.100:8000/api`

---

## 📱 Pantallas Implementadas

### ✅ Completadas

1. **Splash Screen** - Pantalla de bienvenida con logo
2. **Onboarding** - Tutorial de 3 páginas
3. **Login** - Inicio de sesión
4. **Widgets** - Botones y campos de texto personalizados

### 🚧 Pendientes (Próximos pasos)

4. **Register** - Registro de usuario
5. **Configure Profile** - Configuración de preferencias (3 pasos)
6. **Home** - Pantalla principal con navegación
7. **Wardrobe** - Visualización del guardarropa
8. **Camera** - Captura de prendas
9. **Recommendations** - Recomendaciones de outfits
10. **Profile** - Perfil del usuario

---

## 🧪 Probar la Aplicación

### Opción 1: Emulador Android

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en emulador Android
flutter run -d emulator-5554
```

### Opción 2: Navegador Web

```bash
# Ejecutar en Chrome
flutter run -d chrome
```

### Opción 3: Dispositivo Físico

1. Habilitar "Depuración USB" en tu dispositivo Android
2. Conectar el dispositivo por USB
3. Ejecutar:
   ```bash
   flutter run
   ```

---

## 🐛 Solución de Problemas

### Error: "Pub get failed"

```bash
# Limpiar caché
flutter clean
flutter pub get
```

### Error: "No devices found"

```bash
# Verificar dispositivos
flutter devices

# Si no hay dispositivos, crear emulador
flutter emulators --create
```

### Error: "SDK version conflict"

```bash
# Verificar versión de Flutter
flutter --version

# Actualizar Flutter
flutter upgrade
```

### Error: "Provider not found"

Asegúrate de que el widget esté dentro del árbol de `MultiProvider` en `main.dart`.

---

## 📝 Próximos Pasos de Desarrollo

### 1. Completar Pantallas Faltantes

Crear las siguientes pantallas siguiendo el diseño:

- [ ] `register_screen.dart`
- [ ] `configure_profile_screen.dart` (3 pasos)
- [ ] `home_screen.dart` con bottom navigation
- [ ] `wardrobe_screen.dart` con grid de prendas
- [ ] `camera_screen.dart` para capturar fotos
- [ ] `recommendations_screen.dart`
- [ ] `profile_screen.dart`

### 2. Integrar con Backend

- [ ] Implementar autenticación real
- [ ] Conectar carga de imágenes
- [ ] Obtener recomendaciones del backend
- [ ] Sincronizar guardarropa

### 3. Agregar Funcionalidades

- [ ] Filtros de guardarropa
- [ ] Favoritos
- [ ] Compartir outfits
- [ ] Notificaciones
- [ ] Modo offline

---

## 🎯 Comandos Útiles

```bash
# Ejecutar en modo release
flutter run --release

# Generar APK
flutter build apk

# Generar App Bundle (para Play Store)
flutter build appbundle

# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Ver logs
flutter logs
```

---

## 📚 Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design](https://m3.material.io/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

## 🤝 Equipo de Desarrollo

**Frontend:** Persona 1 y Persona 2  
**Backend:** Persona 3  
**Proyecto:** StyleMe - Investigación III

---

## ✅ Checklist de Verificación

Antes de hacer commit:

- [ ] `flutter analyze` sin errores
- [ ] `flutter test` pasa todos los tests
- [ ] Código formateado con `flutter format`
- [ ] Funciona en al menos un dispositivo/emulador
- [ ] No hay warnings en consola
- [ ] Colores y estilos coinciden con el diseño

---

**Última actualización:** 12 de Octubre, 2025  
**Versión:** 1.0.0  
**Estado:** 🚧 En desarrollo activo
