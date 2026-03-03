# Android Build Fix - StyleMe

## Problemas Resueltos

### 1. SDK Version Mismatch
**Error:** Plugin `flutter_plugin_android_lifecycle` requiere Android SDK 35

**Solución:** Actualizado `android/app/build.gradle`:
```gradle
android {
    compileSdk = 35
    
    defaultConfig {
        minSdk = 21
        targetSdk = 35
        ...
    }
}
```

### 2. Shader Compilation Error
**Error:** `Could not write file to shaders/ink_sparkle.frag`

**Solución:** Ejecutar `flutter clean` para limpiar la caché de compilación.

### 3. Permisos de Cámara e Imágenes
**Agregado:** Permisos necesarios en `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.INTERNET"/>

<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
```

### 4. Compatibilidad Web/Mobile para Imágenes
**Problema:** `Image.file()` no funciona en Flutter Web

**Solución:** Implementado código condicional en `camera_screen.dart`:
- **Web:** Usa `Image.network()` con fallback a `Image.memory()`
- **Mobile:** Usa `Image.file()` tradicional

## Pasos para Compilar en Android

1. **Limpiar proyecto:**
```bash
flutter clean
```

2. **Obtener dependencias:**
```bash
flutter pub get
```

3. **Conectar dispositivo Android** (verificar con):
```bash
flutter devices
```

4. **Ejecutar en dispositivo:**
```bash
flutter run
```

## Verificación de Dispositivo

Para ver los dispositivos conectados:
```bash
flutter devices
```

Deberías ver algo como:
```
SM M315F (mobile) • XXXXXX • android-arm64 • Android XX (API XX)
```

## Troubleshooting Adicional

### Si persiste el error de shader (ink_sparkle.frag):
Este es un problema conocido en Windows con rutas largas. Soluciones:

**Opción 1: Compilar en modo Release**
```bash
flutter build apk --release
flutter install -d <DEVICE_ID>
```

**Opción 2: Usar el script de compilación**
```bash
build_android.bat
```

**Opción 3: Habilitar rutas largas en Windows**
1. Abrir PowerShell como Administrador
2. Ejecutar:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```
3. Reiniciar el sistema
4. Ejecutar `flutter clean` y volver a intentar

**Opción 4: Mover proyecto a ruta más corta**
Mover el proyecto a una ruta como `C:\StyleMe\` para evitar problemas con rutas largas.

### Compilación Manual:
1. Eliminar carpeta `build` manualmente
2. Ejecutar `flutter clean`
3. Reiniciar Android Studio/VS Code
4. Ejecutar `flutter pub get`
5. Crear directorios manualmente:
```powershell
New-Item -ItemType Directory -Force -Path "build\app\intermediates\flutter\debug\flutter_assets\shaders"
```
6. Intentar `flutter run` nuevamente

### Si hay problemas de permisos en runtime:
La app solicitará permisos automáticamente cuando intentes:
- Tomar una foto (permiso de CAMERA)
- Seleccionar de galería (permiso de READ_MEDIA_IMAGES)

### Si el backend no responde:
1. Verificar que el backend esté corriendo
2. Si estás en un dispositivo físico, asegúrate de que el backend esté accesible en la red local
3. Actualizar la URL del backend en `lib/core/constants/app_constants.dart` con la IP local de tu computadora

## Cambios Realizados

### Archivos Modificados:
1. ✅ `android/app/build.gradle` - SDK versions actualizadas
2. ✅ `android/app/src/main/AndroidManifest.xml` - Permisos agregados
3. ✅ `lib/ui/screens/camera_screen.dart` - Compatibilidad web/mobile

### Próximos Pasos:
- Probar la funcionalidad de cámara en dispositivo físico
- Verificar la integración con el backend
- Probar el flujo completo de detección de prendas
