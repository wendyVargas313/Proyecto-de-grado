# ⚠️ IMPORTANTE: Cómo Iniciar el Backend Correctamente

## ❌ INCORRECTO (No funciona desde el celular)
```bash
python manage.py runserver
# O
python manage.py runserver 127.0.0.1:8000
```

**Problema:** Solo escucha en localhost, el celular no puede conectarse.

---

## ✅ CORRECTO (Funciona desde el celular)
```bash
python manage.py runserver 0.0.0.0:8000
```

**Solución:** Escucha en todas las interfaces de red, accesible desde otros dispositivos.

---

## 🔍 Cómo Verificar

### Ver si el backend está escuchando correctamente:
```cmd
netstat -ano | findstr :8000
```

**Resultado Correcto:**
```
TCP    0.0.0.0:8000           0.0.0.0:0              LISTENING
```

**Resultado Incorrecto:**
```
TCP    127.0.0.1:8000         0.0.0.0:0              LISTENING
```

---

## 🚀 Reiniciar Backend Correctamente

### Opción 1: Usar el Script
```bash
S:\REINICIAR_TODO.bat
```

### Opción 2: Manual
```bash
# 1. Detener backend actual
taskkill /F /IM python.exe

# 2. Iniciar correctamente
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

---

## 📋 Diferencias

| Comando | Escucha en | Accesible desde |
|---------|-----------|-----------------|
| `runserver` | 127.0.0.1:8000 | Solo localhost |
| `runserver 127.0.0.1:8000` | 127.0.0.1:8000 | Solo localhost |
| `runserver 0.0.0.0:8000` | 0.0.0.0:8000 | Toda la red |

---

## 🐛 Síntomas de Problema

Si ves este error en la app:
```
Connection timed out
address = 192.168.0.7, port = 8000
```

**Causa:** Backend iniciado con `127.0.0.1` en lugar de `0.0.0.0`

**Solución:** Reiniciar con `0.0.0.0:8000`

---

## 💡 Nota de Seguridad

`0.0.0.0:8000` es seguro para desarrollo local porque:
- Solo funciona en tu red WiFi local
- No es accesible desde internet
- Django tiene `DEBUG = True` solo para desarrollo

**Para producción:** Usa un servidor web real (Nginx, Apache) con HTTPS.

---

## ✅ Checklist

Antes de probar la app en el celular:

- [ ] Backend iniciado con `0.0.0.0:8000`
- [ ] Verificado con `netstat -ano | findstr :8000`
- [ ] Celular y PC en la misma red WiFi
- [ ] IP configurada en `app_constants.dart`
- [ ] `ALLOWED_HOSTS` incluye tu IP

---

## 🎯 Comando Definitivo

**SIEMPRE usa este comando para iniciar el backend:**
```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

No uses `runserver` solo, siempre especifica `0.0.0.0:8000`.
