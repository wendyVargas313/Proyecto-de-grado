# ⚡ Inicio Rápido - StyleMe Frontend

**¡Empieza a desarrollar en 5 minutos!**

---

## 🚀 Paso 1: Instalar Dependencias

```bash
# Navegar al directorio
cd styleme_front

# Instalar dependencias
flutter pub get
```

**Salida esperada:**
```
Running "flutter pub get" in styleme_front...
Resolving dependencies...
Got dependencies!
```

---

## 🎯 Paso 2: Ejecutar la Aplicación

```bash
# Ejecutar en modo debug
flutter run
```

**Opciones de dispositivo:**

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en Chrome (Web)
flutter run -d chrome

# Ejecutar en Windows
flutter run -d windows

# Ejecutar en emulador Android
flutter run -d emulator-5554
```

---

## 📱 Paso 3: Ver las Pantallas

Al ejecutar, verás esta secuencia:

1. **Splash Screen** (3 segundos)
   - Logo STYLEME
   - Slogan
   - Gradiente naranja (#AF9338 → #E35B18)

2. **Onboarding** (3 páginas)
   - Diseña tu atuendo
   - Captura tus prendas
   - Recibe recomendaciones
   - Botón "Comenzar"

3. **Login Screen**
   - Campo de email
   - Campo de contraseña
   - Botón "Iniciar sesión"
   - Link a registro

---

## 🎨 Verificar Colores

Los colores deben verse exactamente así:

- **Gradiente de fondo:** Naranja claro → Naranja oscuro
- **Botones:** Naranja melocotón (#FFA75D)
- **Campos de texto:** Fondo blanco semi-transparente
- **Texto:** Blanco sobre gradiente

---

## 🐛 Solución Rápida de Problemas

### Error: "No devices found"

```bash
# Opción 1: Ejecutar en Chrome
flutter run -d chrome

# Opción 2: Crear emulador
flutter emulators --create
```

### Error: "Pub get failed"

```bash
flutter clean
flutter pub get
```

### Error: "SDK version conflict"

Verifica que tu `pubspec.yaml` tenga:
```yaml
environment:
  sdk: ^3.5.3
```

---

## 📝 Próximos Pasos

### 1. Agregar Imagen de Fondo

Coloca la imagen de la pareja en:
```
assets/images/splash_background.jpg
```

Luego actualiza `splash_screen.dart`:
```dart
// Reemplazar el Container con:
Image.asset(
  'assets/images/splash_background.jpg',
  fit: BoxFit.cover,
)
```

### 2. Crear Pantalla de Registro

```bash
# Crear archivo
New-Item lib\ui\screens\register_screen.dart
```

Copia la estructura de `login_screen.dart` y modifica.

### 3. Probar con Backend

Asegúrate de que el backend esté corriendo:
```bash
# En otra terminal, en styleme_back:
python manage.py runserver
```

---

## 🎯 Comandos Útiles

```bash
# Ver logs en tiempo real
flutter logs

# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Hot reload (mientras la app corre)
# Presiona 'r' en la terminal

# Hot restart (mientras la app corre)
# Presiona 'R' en la terminal

# Salir de la app
# Presiona 'q' en la terminal
```

---

## 📚 Estructura de Archivos

```
lib/
├── core/constants/       # ✅ Colores, estilos, constantes
├── models/              # ✅ Modelos de datos
├── providers/           # ✅ Estado de la app
├── services/            # ✅ API y storage
├── routes/              # ✅ Navegación
├── ui/
│   ├── screens/         # ✅ Splash, Onboarding, Login
│   └── widgets/         # ✅ Botones, campos de texto
└── main.dart            # ✅ Punto de entrada
```

---

## ✅ Checklist de Verificación

Antes de continuar, verifica:

- [ ] `flutter pub get` ejecutado sin errores
- [ ] App se ejecuta en al menos un dispositivo
- [ ] Splash screen se muestra correctamente
- [ ] Onboarding tiene 3 páginas
- [ ] Login screen tiene formulario funcional
- [ ] Colores coinciden con el diseño
- [ ] Navegación funciona entre pantallas

---

## 🎨 Personalización

### Cambiar Colores

Edita `lib/core/constants/app_colors.dart`:
```dart
static const Color primaryOrange = Color(0xFFAF9338);
static const Color secondaryOrange = Color(0xFFE35B18);
static const Color buttonOrange = Color(0xFFFFA75D);
```

### Cambiar Textos

Edita `lib/core/constants/app_constants.dart`:
```dart
static const String appName = 'STYLEME';
static const String appSlogan = 'Tu estilo, tus reglas...';
```

### Cambiar URL del Backend

Edita `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
// Para dispositivo físico:
// static const String baseUrl = 'http://192.168.1.100:8000/api';
```

---

## 🚀 ¡Listo para Desarrollar!

La estructura base está completa. Ahora puedes:

1. **Crear más pantallas** siguiendo el patrón existente
2. **Agregar widgets** en `lib/ui/widgets/`
3. **Conectar con el backend** usando `ApiService`
4. **Gestionar estado** con los `Providers`

---

## 📞 Ayuda

Si tienes problemas:

1. Lee `INSTRUCCIONES.md` para guía detallada
2. Lee `RESUMEN_IMPLEMENTACION.md` para ver qué falta
3. Ejecuta `flutter doctor` para verificar instalación

---

**¡Feliz desarrollo!** 🎉

**Última actualización:** 12 de Octubre, 2025
