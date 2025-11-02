# 🚀 Guía Rápida de Ejecución - StyleMe

## ⚠️ REGLA DE ORO
**SIEMPRE ejecuta Flutter desde la ruta corta `S:\styleme_front`**

❌ NO uses: `D:\wendy\Universidad\9. Semestre 2025-2\...`  
✅ SÍ usa: `S:\styleme_front`

---

## 🎯 Ejecución Rápida (3 Pasos)

### 1️⃣ Iniciar Backend
```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

### 2️⃣ Ejecutar Flutter (en otra terminal)
```bash
cd S:\styleme_front
flutter run -d R58N408972H
```

### 3️⃣ Probar en el Celular
- Espera a que compile (1-2 minutos)
- Abre la app
- Ve a Cámara
- Detecta prendas ✅

---

## 📦 Scripts Disponibles

### Ejecutar Todo Automáticamente
```bash
S:\REINICIAR_TODO.bat
```
Inicia backend y Flutter en ventanas separadas.

### Solo Flutter
```bash
S:\EJECUTAR_FLUTTER.bat
```

### Recrear Unidad S: (después de reiniciar Windows)
```bash
S:\CREAR_UNIDAD_S.bat
```

### Configurar IP del Backend
```bash
S:\CONFIGURAR_IP.bat
```

---

## 🔧 Comandos Útiles

### Ver Dispositivos Conectados
```bash
flutter devices
```

### Limpiar Proyecto
```bash
cd S:\styleme_front
flutter clean
flutter pub get
```

### Compilar APK Release
```bash
cd S:\styleme_front
flutter build apk --release
```

### Ver Logs
```bash
flutter logs
```

### Hot Reload (app corriendo)
Presiona `r` en la terminal

### Hot Restart (app corriendo)
Presiona `R` en la terminal

### Salir
Presiona `q` en la terminal

---

## 📱 Información del Dispositivo

```
Nombre: SM M315F
ID: R58N408972H
Android: 12 (API 31)
```

---

## 🌐 Configuración de Red

### IP del Backend
```
192.168.0.7:8000
```

### Endpoints Disponibles
- `http://192.168.0.7:8000/api/detect-clothing/`
- `http://192.168.0.7:8000/api/recommend/`
- `http://192.168.0.7:8000/api/recommend-outfit-ai/`

### Verificar Backend desde Celular
Abre en el navegador:
```
http://192.168.0.7:8000/api/detect-clothing/
```

---

## 🐛 Solución de Problemas

### Error: "Unable to open APK"
**Causa:** Ejecutaste desde la ruta larga  
**Solución:** Usa `S:\styleme_front`

### Error: "Invalid HTTP_HOST"
**Causa:** IP no está en ALLOWED_HOSTS  
**Solución:** Ya está arreglado en `settings.py`

### Error: "Connection refused"
**Causa:** Backend no está corriendo o firewall bloqueando  
**Solución:**
1. Verifica que el backend esté corriendo
2. Desactiva el firewall temporalmente
3. Verifica que estés en la misma red WiFi

### La unidad S: no existe
**Causa:** Reiniciaste Windows  
**Solución:** Ejecuta `S:\CREAR_UNIDAD_S.bat`

### Flutter no compila
**Solución:**
```bash
cd S:\styleme_front
flutter clean
flutter pub get
flutter run -d R58N408972H
```

---

## 📂 Estructura del Proyecto

```
S:\
├── styleme_front\              Frontend Flutter
│   ├── lib\
│   ├── android\
│   └── build\
├── styleme_back\               Backend Django
│   ├── recommendations\
│   ├── backend\
│   └── manage.py
├── EJECUTAR_FLUTTER.bat        Ejecutar Flutter
├── REINICIAR_TODO.bat          Reiniciar todo
├── CREAR_UNIDAD_S.bat          Recrear unidad S:
├── CONFIGURAR_IP.bat           Configurar IP
└── GUIA_RAPIDA_EJECUCION.md    Este archivo
```

---

## ✅ Checklist Antes de Ejecutar

- [ ] La unidad S: existe (ejecuta `dir S:\`)
- [ ] Celular conectado por USB
- [ ] Depuración USB habilitada
- [ ] Celular y PC en la misma red WiFi
- [ ] Backend corriendo en `0.0.0.0:8000`
- [ ] IP configurada en `app_constants.dart`

---

## 🎉 Todo Listo

Si seguiste estos pasos, la app debería estar funcionando en tu celular con:
- ✅ Detección de prendas con IA
- ✅ Guardarropa funcional
- ✅ Recomendaciones de outfits

¡A probar! 🚀
