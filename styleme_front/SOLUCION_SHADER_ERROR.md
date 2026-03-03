# Solución al Error de Shader en Android

## Problema
```
Could not write file to ...\shaders/ink_sparkle.frag
ShaderCompilerException: Shader compilation failed
```

Este error ocurre en Windows debido a limitaciones con rutas largas de archivos.

## ✅ SOLUCIÓN RECOMENDADA: Compilar en Release

En lugar de `flutter run`, usa estos comandos:

### Paso 1: Compilar APK
```bash
flutter build apk --release
```

### Paso 2: Instalar en dispositivo
```bash
flutter install -d R58N408972H
```

O usa el script automatizado:
```bash
build_android.bat
```

---

## Soluciones Alternativas

### Opción A: Habilitar Rutas Largas en Windows (REQUIERE ADMIN)

1. **Abrir PowerShell como Administrador**
   - Buscar "PowerShell" en el menú inicio
   - Click derecho → "Ejecutar como administrador"

2. **Ejecutar este comando:**
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```

3. **Reiniciar Windows**

4. **Volver a intentar:**
```bash
flutter clean
flutter pub get
flutter run -d R58N408972H
```

### Opción B: Mover Proyecto a Ruta Corta

1. **Mover el proyecto** a una ubicación con ruta más corta, por ejemplo:
   - De: `D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo\styleme_front`
   - A: `C:\StyleMe\styleme_front`

2. **Ejecutar:**
```bash
flutter clean
flutter pub get
flutter run
```

### Opción C: Usar Subst (Crear Unidad Virtual)

1. **Crear unidad virtual** (como Administrador):
```cmd
subst S: "D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo"
```

2. **Navegar a la nueva unidad:**
```cmd
cd S:\styleme_front
```

3. **Ejecutar Flutter:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## Para Desarrollo Rápido

### Opción 1: APK Release + Hot Reload Manual
```bash
# Compilar e instalar
flutter build apk --release
flutter install -d R58N408972H

# Cuando hagas cambios, recompila e instala de nuevo
```

### Opción 2: Usar Emulador Android
El emulador a veces no tiene este problema:
```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

---

## Verificar Instalación

Después de compilar el APK, verifica que se instaló:

```bash
# Ver dispositivos conectados
flutter devices

# Instalar APK manualmente
flutter install -d R58N408972H

# O instalar desde el archivo
adb install build\app\outputs\flutter-apk\app-release.apk
```

---

## Notas Importantes

1. **El modo Release no tiene hot reload**, necesitarás recompilar cada vez que hagas cambios
2. **El APK release es más pequeño y rápido** que el debug
3. **Para desarrollo activo**, considera usar un emulador o habilitar rutas largas en Windows
4. **El error NO afecta la funcionalidad** de la app, solo impide la compilación

---

## Estado Actual

✅ **Configuración Android completada:**
- SDK 35 configurado
- Permisos de cámara agregados
- Compatibilidad web/mobile implementada

❌ **Problema pendiente:**
- Error de shader por rutas largas en Windows

🔧 **Solución temporal:**
- Usar `flutter build apk --release` + `flutter install`
