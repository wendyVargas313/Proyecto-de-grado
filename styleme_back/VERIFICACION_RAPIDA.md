# ⚡ Verificación Rápida - Backend

**Para verificar que la carga de imágenes funciona correctamente.**

---

## 🚀 Inicio Rápido (5 minutos)

### 1️⃣ Preparar el Entorno (Terminal 1)

```powershell
# Ir al directorio del backend
cd styleme_back

# Activar entorno virtual
.\env\Scripts\activate

# Iniciar MongoDB (si no está corriendo)
net start MongoDB

# Iniciar servidor Django
python manage.py runserver
```

**Mantén esta terminal abierta** ✋

---

### 2️⃣ Crear Usuario de Prueba (Terminal 2)

```powershell
# Abrir nueva terminal
cd styleme_back

# Activar entorno virtual
.\env\Scripts\activate

# Crear usuario
python crear_usuario_prueba.py
# Seleccionar opción 1
```

---

### 3️⃣ Probar con Script Automático (Terminal 2)

```powershell
# Ejecutar script de prueba
python test_carga_imagenes.py
```

El script buscará automáticamente imágenes de prueba.

---

### 4️⃣ Probar Manualmente con cURL (Terminal 2)

```powershell
# Reemplaza "foto.jpg" con tu imagen
curl -X POST http://localhost:8000/api/detect-clothing/ `
  -F "email=test@example.com" `
  -F "image=@foto.jpg"
```

---

## ✅ Resultado Esperado

Si todo funciona, deberías ver:

```json
{
  "success": true,
  "message": "✅ Carga completada exitosamente...",
  "total_prendas_detectadas": 1,
  "prendas": [
    {
      "tipo": "camiseta",
      "imagen_id": "670abc...",
      "imagen_url": "/api/images/670abc...",
      "confianza": "0.85"
    }
  ]
}
```

---

## 🔍 Verificar en MongoDB

```powershell
# Conectar a MongoDB
mongosh

# Cambiar a la base de datos
use styleme_db

# Ver usuario con prendas
db.usuarios.findOne({correo: "test@example.com"})

# Ver imágenes en GridFS
db.fs.files.find({"metadata.user_email": "test@example.com"}).pretty()

# Salir
exit
```

---

## 🌐 Ver Imagen en Navegador

1. Copia el `imagen_url` de la respuesta (ejemplo: `/api/images/670abc...`)
2. Abre en el navegador:
   ```
   http://localhost:8000/api/images/670abc...
   ```
3. ✅ Deberías ver la imagen cargada

---

## 🛠️ Script de Verificación Automática

```powershell
# Ejecutar verificación del sistema
.\verificar_backend.ps1
```

Este script verifica:
- ✅ Python instalado
- ✅ MongoDB corriendo
- ✅ Servidor Django activo
- ✅ Estructura del proyecto correcta
- ✅ Modelo YOLO disponible

---

## 🐛 Solución Rápida de Problemas

### MongoDB no conecta

```powershell
net start MongoDB
```

### Puerto 8000 ocupado

```powershell
python manage.py runserver 8001
# Actualizar URL en pruebas a localhost:8001
```

### Usuario no encontrado

```powershell
python crear_usuario_prueba.py
```

### No se detectaron prendas

- Usa imágenes con prendas claras y visibles
- Fondo simple y buena iluminación
- Formatos: JPG o PNG

---

## 📊 Verificación Completa

Para una verificación más exhaustiva:

```powershell
# Leer la guía completa
code GUIA_VERIFICACION_BACKEND.md
# o
notepad GUIA_VERIFICACION_BACKEND.md
```

---

## 📝 Checklist Mínimo

- [ ] MongoDB está corriendo
- [ ] Servidor Django está corriendo (puerto 8000)
- [ ] Usuario de prueba creado (`test@example.com`)
- [ ] Endpoint acepta imagen y responde 200 OK
- [ ] Respuesta JSON tiene `success: true`
- [ ] Se detectan prendas (campo `tipo` presente)
- [ ] Imagen se guarda en GridFS (verificar en MongoDB)
- [ ] Imagen se puede ver en navegador

---

## 🎯 Si Todo Funciona

**¡Excelente!** El backend está listo para:

1. ✅ Integración con el frontend Flutter
2. ✅ Desarrollo de la UI de carga de imágenes
3. ✅ Pruebas con dispositivos móviles

**Próximo paso:** Compartir con el equipo de frontend:
- URL del endpoint: `http://localhost:8000/api/detect-clothing/`
- Documentación: `API_CARGA_IMAGENES.md`
- Ejemplos de respuesta

---

## 📚 Documentación Adicional

| Archivo | Descripción |
|---------|-------------|
| `GUIA_VERIFICACION_BACKEND.md` | Guía completa paso a paso |
| `API_CARGA_IMAGENES.md` | Documentación del API |
| `COMANDOS_UTILES.md` | Comandos frecuentes |
| `ARQUITECTURA_MODULAR.md` | Explicación de la arquitectura |

---

## 💡 Tips

1. **Siempre verifica MongoDB primero** - Sin MongoDB, nada funciona
2. **Usa imágenes reales de prendas** - YOLO necesita imágenes claras
3. **Revisa los logs** - `logs/django.log` tiene información útil
4. **Una terminal para el servidor** - Mantén el servidor corriendo en una terminal separada

---

**Tiempo estimado:** 5-10 minutos  
**Dificultad:** Básica  
**Última actualización:** 08 de Octubre, 2025
