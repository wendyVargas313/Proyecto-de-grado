# 📱 Instrucciones para Ejecutar StyleMe en Móvil

## ✅ Problema Resuelto: Rutas Largas en Windows

Se creó una unidad virtual `S:` que apunta a tu proyecto para evitar problemas con rutas largas.

---

## 🚀 Cómo Ejecutar la App en tu Celular

### Opción 1: Usando la Ruta Corta (RECOMENDADO)

1. **Abrir terminal en la ruta corta:**
```cmd
cd S:\styleme_front
```

2. **Conectar tu celular** por USB y habilitar depuración USB

3. **Verificar que el dispositivo esté conectado:**
```bash
flutter devices
```
Deberías ver: `SM M315F (mobile) • R58N408972H • android-arm64 • Android 12 (API 31)`

4. **Ejecutar la app:**
```bash
flutter run -d R58N408972H
```

O simplemente ejecuta:
```bash
run_on_device.bat
```

### Opción 2: Compilar APK e Instalar

Si `flutter run` sigue dando problemas:

```bash
cd S:\styleme_front
flutter build apk --release
flutter install -d R58N408972H
```

O usa el script:
```bash
build_android.bat
```

---

## 📝 Notas Importantes

### La Unidad Virtual S:

- **S:** apunta a: `D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo`
- Esto resuelve el problema de rutas largas en Windows
- La unidad se mantiene hasta que reinicies Windows
- Para recrearla después de reiniciar:
```cmd
subst S: "D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo"
```

### Comandos Útiles

**Ver dispositivos conectados:**
```bash
flutter devices
```

**Limpiar proyecto:**
```bash
cd S:\styleme_front
flutter clean
flutter pub get
```

**Ver logs en tiempo real:**
```bash
flutter logs
```

**Hot Reload (cuando la app está corriendo):**
- Presiona `r` en la terminal
- Presiona `R` para hot restart completo
- Presiona `q` para salir

---

## 🔧 Configuración del Backend

Para que la app se conecte al backend desde tu celular:

1. **Obtener tu IP local:**
```cmd
ipconfig
```
Busca tu dirección IPv4 (ejemplo: `192.168.1.100`)

2. **Actualizar la URL del backend:**

Edita `S:\styleme_front\lib\core\constants\app_constants.dart`:

```dart
class AppConstants {
  // Cambiar de localhost a tu IP local
  static const String baseUrl = 'http://192.168.1.100:8000';  // <-- Tu IP aquí
  
  // ... resto del código
}
```

3. **Asegúrate de que el backend esté corriendo:**
```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

4. **Verifica que tu celular y PC estén en la misma red WiFi**

---

## 🐛 Troubleshooting

### Error: "No devices found"
- Verifica que la depuración USB esté habilitada en tu celular
- Desconecta y vuelve a conectar el cable USB
- Acepta el diálogo de "Permitir depuración USB" en tu celular

### Error: "Gradle build failed"
- Usa la ruta corta: `cd S:\styleme_front`
- Ejecuta: `flutter clean && flutter pub get`
- Intenta de nuevo

### Error: "Could not connect to backend"
- Verifica que el backend esté corriendo
- Verifica que uses tu IP local (no localhost)
- Verifica que ambos dispositivos estén en la misma red WiFi
- Desactiva el firewall temporalmente para probar

### La app se cierra inmediatamente
- Revisa los logs: `flutter logs`
- Verifica los permisos en el celular (Configuración → Apps → StyleMe → Permisos)

---

## ✨ Características Implementadas

✅ **Compatibilidad Web y Mobile**
- La app funciona tanto en Chrome como en dispositivos móviles
- Manejo correcto de imágenes en ambas plataformas

✅ **Permisos de Android**
- Cámara
- Galería de fotos
- Internet

✅ **SDK Actualizado**
- Android SDK 35
- Compatible con Android 5.0+ (API 21+)

---

## 📂 Estructura de Rutas

```
S:\                                    (Unidad virtual)
├── styleme_front\                     (Frontend Flutter)
│   ├── lib\
│   ├── android\
│   ├── build_android.bat              (Script de compilación)
│   ├── run_on_device.bat              (Script de ejecución)
│   └── INSTRUCCIONES_MOBILE.md        (Este archivo)
└── styleme_back\                      (Backend Django)
```

---

## 🎯 Próximos Pasos

1. ✅ Ejecutar la app en tu celular
2. ⏳ Probar la funcionalidad de cámara
3. ⏳ Probar la detección de prendas
4. ⏳ Verificar la integración con el backend
5. ⏳ Probar el flujo completo de la app

---

## 💡 Tips para Desarrollo

- **Usa Hot Reload** (`r` en la terminal) para ver cambios rápidamente
- **Mantén el backend corriendo** mientras pruebas
- **Revisa los logs** con `flutter logs` si algo no funciona
- **Usa la ruta corta S:** para evitar problemas de compilación

¡Listo para probar! 🚀
