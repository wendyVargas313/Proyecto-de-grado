# ⚠️ IMPORTANTE: Cómo Ejecutar Flutter

## ❌ NO FUNCIONA (Ruta larga con tildes)
```
D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo\styleme_front
```

**Problema:** Windows no puede manejar rutas largas con caracteres especiales (tildes, ñ, etc.)

---

## ✅ SÍ FUNCIONA (Ruta corta)
```
S:\styleme_front
```

**Solución:** Usar la unidad virtual `S:` que creamos

---

## 🚀 Cómo Ejecutar Flutter Correctamente

### Opción 1: Usar el Script (MÁS FÁCIL)
```bash
S:\EJECUTAR_FLUTTER.bat
```

### Opción 2: Desde CMD/PowerShell
```bash
cd S:\styleme_front
flutter run -d R58N408972H
```

### Opción 3: Desde VS Code
1. Abre la carpeta: `S:\styleme_front`
2. Presiona F5 o usa el botón "Run"

---

## 📋 Comandos Útiles (SIEMPRE desde S:)

### Ejecutar en Celular
```bash
cd S:\styleme_front
flutter run -d R58N408972H
```

### Compilar APK
```bash
cd S:\styleme_front
flutter build apk --release
```

### Limpiar Proyecto
```bash
cd S:\styleme_front
flutter clean
flutter pub get
```

### Hot Reload
Cuando la app está corriendo, presiona `r` en la terminal

### Hot Restart
Cuando la app está corriendo, presiona `R` en la terminal

---

## 🔧 Si la Unidad S: No Existe

Después de reiniciar Windows, la unidad S: desaparece. Para recrearla:

```cmd
subst S: "D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo"
```

O ejecuta:
```bash
S:\CREAR_UNIDAD_S.bat
```

---

## 💡 Configuración de VS Code

Si usas VS Code, abre siempre el proyecto desde:
```
Archivo → Abrir Carpeta → S:\styleme_front
```

**NO abras desde:**
```
D:\wendy\Universidad\...
```

---

## 🎯 Resumen

✅ **SIEMPRE usa:** `S:\styleme_front`  
❌ **NUNCA uses:** `D:\wendy\Universidad\9. Semestre 2025-2\...`

La ruta larga causa errores de compilación en Android.
