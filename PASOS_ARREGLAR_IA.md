# 🚀 Pasos Rápidos para Arreglar la IA

## ✅ Problema Actual
La app funciona en el celular pero:
- ❌ Error al detectar prendas (no se conecta al backend)
- ❌ Modelo recomendador usa datos simulados

## 🔧 Solución Rápida (5 minutos)

### Paso 1: Configurar IP del Backend

**Opción A: Usar el script automático**
```bash
S:\CONFIGURAR_IP.bat
```
Este script:
1. Obtiene tu IP automáticamente
2. Te muestra las instrucciones
3. Abre el archivo para editar

**Opción B: Manual**
1. Obtener tu IP:
   ```cmd
   ipconfig
   ```
   Busca tu IPv4, ejemplo: `192.168.1.100`

2. Editar `S:\styleme_front\lib\core\constants\app_constants.dart`:
   ```dart
   // Cambiar de:
   static const String baseUrl = 'http://localhost:8000/api';
   
   // A (con TU IP):
   static const String baseUrl = 'http://192.168.1.100:8000/api';
   ```

3. Hot reload en Flutter:
   - Si la app ya está corriendo, presiona `r` en la terminal
   - Si no, ejecuta: `cd S:\styleme_front && flutter run -d R58N408972H`

### Paso 2: Iniciar Backend Correctamente

```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

**IMPORTANTE:** Usa `0.0.0.0:8000` (no `127.0.0.1:8000`)

### Paso 3: Verificar Conexión

1. Desde el celular, abre el navegador
2. Ve a: `http://TU_IP:8000/api/`
3. Deberías ver la API de Django

### Paso 4: Probar Detección

1. Abre la app en el celular
2. Ve a la pestaña de Cámara (botón naranja del centro)
3. Selecciona una imagen
4. Presiona "Detectar"
5. ✅ Debería funcionar ahora

---

## 🤖 Arreglar Modelo Recomendador (Opcional)

Si quieres usar el modelo real en lugar de datos simulados:

### 1. Verificar que el Modelo Existe

```bash
cd S:\styleme_back
dir recommendations\ia\models\modelo_recomendador_outfits.pkl
```

### 2. Si NO existe:

**Opción A: Entrenar en Colab**
1. Abre tu notebook de Colab
2. Entrena el modelo
3. Descarga el archivo `.pkl`
4. Colócalo en: `S:\styleme_back\recommendations\ia\models\`

**Opción B: Usar el modelo actual**
El modelo ya está cargado en `recommender.py` línea 32:
```python
kmeans_model = joblib.load(model_path)
```

### 3. Actualizar la Función de Recomendación

Edita: `S:\styleme_back\recommendations\ia\recommender.py`

Reemplaza la función `generate_outfits()` con la versión mejorada del archivo `ARREGLAR_IA.md`

---

## 📋 Checklist Rápido

### Configuración Básica (NECESARIO)
- [ ] Obtener IP local con `ipconfig`
- [ ] Cambiar `localhost` por IP en `app_constants.dart`
- [ ] Hot reload en Flutter (`r` en terminal)
- [ ] Iniciar backend con `0.0.0.0:8000`
- [ ] Verificar conexión desde navegador del celular
- [ ] Probar detección de prendas

### Modelo Recomendador (OPCIONAL)
- [ ] Verificar que existe `modelo_recomendador_outfits.pkl`
- [ ] Actualizar función `generate_outfits()` en `recommender.py`
- [ ] Reiniciar backend
- [ ] Probar recomendaciones

---

## 🎯 Comandos Rápidos

### Terminal 1: Flutter
```bash
cd S:\styleme_front
flutter run -d R58N408972H
# Presiona 'r' para hot reload después de cambiar la IP
```

### Terminal 2: Backend
```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

---

## 🐛 Problemas Comunes

### "Connection refused" en la app
- ✅ Verifica que el backend esté corriendo
- ✅ Verifica que uses `0.0.0.0:8000`
- ✅ Verifica que celular y PC estén en la misma WiFi
- ✅ Desactiva el firewall temporalmente

### "No se detectan prendas"
- ✅ Verifica que `yolov8n.pt` exista en `recommendations/ia/models/`
- ✅ Verifica los logs del backend para ver errores

### "Hot reload no funciona"
- ✅ Reinicia la app completamente: `flutter run -d R58N408972H`

---

## 📱 Flujo de Prueba Completo

1. **Iniciar Backend**
   ```bash
   cd S:\styleme_back
   python manage.py runserver 0.0.0.0:8000
   ```

2. **Ejecutar App**
   ```bash
   cd S:\styleme_front
   flutter run -d R58N408972H
   ```

3. **Probar en el Celular**
   - Login con email de prueba
   - Ir a pestaña Cámara
   - Seleccionar imagen
   - Detectar prenda
   - Ver resultado

---

## 💡 Tips

- **IP Dinámica:** Tu IP puede cambiar si te reconectas al WiFi
- **Firewall:** Windows Defender puede bloquear conexiones
- **Red WiFi:** Asegúrate de usar la misma red en ambos dispositivos
- **Hot Reload:** Más rápido que recompilar toda la app

---

## 📞 Verificación Rápida

### ¿Backend accesible?
```
http://TU_IP:8000/api/
```
Debes ver la API de Django

### ¿App conectada?
En la app, intenta detectar una prenda. Si funciona, ¡todo está bien! ✅

---

## 🎉 Resultado Esperado

Después de seguir estos pasos:
- ✅ La app se conecta al backend desde el celular
- ✅ La detección de prendas funciona
- ✅ Las prendas se guardan en el guardarropa
- ✅ Las recomendaciones funcionan (simuladas o con modelo real)

¡Listo para probar! 🚀
