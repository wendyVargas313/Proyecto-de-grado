# 🤖 Guía para Arreglar la Integración de IA

## 📋 Problemas Identificados

### 1. ❌ Error de Conexión al Backend
**Problema:** La app intenta conectarse a `localhost:8000` pero desde el celular no funciona.

**Solución:** Cambiar `localhost` por la IP local de tu PC.

### 2. ❌ Modelo Recomendador con Datos Simulados
**Problema:** El modelo en `recommender.py` usa datos simulados de Colab.

**Solución:** Integrar el modelo real entrenado.

---

## 🔧 Solución 1: Configurar IP del Backend

### Paso 1: Obtener tu IP Local

En PowerShell o CMD:
```cmd
ipconfig
```

Busca tu dirección IPv4, ejemplo: `192.168.1.100`

### Paso 2: Actualizar Frontend

Edita: `S:\styleme_front\lib\core\constants\app_constants.dart`

```dart
class AppConstants {
  // Cambiar de localhost a tu IP local
  static const String baseUrl = 'http://192.168.1.100:8000/api';  // <-- CAMBIAR AQUÍ
  
  // ... resto del código
}
```

### Paso 3: Recompilar la App

```bash
cd S:\styleme_front
flutter run -d R58N408972H
```

O usa el hot reload si ya está corriendo (presiona `r` en la terminal).

### Paso 4: Iniciar Backend con IP Accesible

```bash
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
```

**Importante:** Usa `0.0.0.0:8000` en lugar de `127.0.0.1:8000` para que sea accesible desde otros dispositivos.

### Paso 5: Verificar Conexión

1. Asegúrate de que tu celular y PC estén en la misma red WiFi
2. Desde el celular, abre el navegador y ve a: `http://TU_IP:8000/api/`
3. Deberías ver la API de Django

---

## 🤖 Solución 2: Integrar Modelo Recomendador Real

### Contexto Actual

El archivo `recommendations/ia/recommender.py` tiene:
- ✅ Modelo KMeans cargado desde `modelo_recomendador_outfits.pkl`
- ❌ Función `generate_outfits()` usa combinaciones aleatorias (simuladas)
- ✅ Función `predict_outfit_group()` usa el modelo real

### Paso 1: Verificar que el Modelo Existe

```bash
cd S:\styleme_back
dir recommendations\ia\models\modelo_recomendador_outfits.pkl
```

Si no existe, necesitas:
1. Entrenar el modelo en Colab
2. Descargar el archivo `.pkl`
3. Colocarlo en `recommendations/ia/models/`

### Paso 2: Actualizar `recommender.py`

Necesitas modificar la función `generate_outfits()` para usar el modelo real en lugar de combinaciones aleatorias.

**Archivo actual:** `S:\styleme_back\recommendations\ia\recommender.py`

```python
def generate_outfits(wardrobe, preferences):
    # Actualmente usa random.choice() - SIMULADO
    # Necesita usar el modelo KMeans real
```

### Paso 3: Implementar Recomendación con IA

Aquí está la implementación mejorada:

```python
def generate_outfits_with_ai(wardrobe, preferences):
    """
    Genera outfits usando el modelo KMeans entrenado.
    
    Args:
        wardrobe: Lista de prendas del guardarropa
        preferences: Preferencias del usuario (temporada, ocasión, etc.)
    
    Returns:
        Lista de outfits recomendados
    """
    if not wardrobe:
        return []
    
    # Filtrar prendas por tipo
    tops = [p for p in wardrobe if p.tipo in ['camiseta', 'blusa', 'suéter']]
    bottoms = [p for p in wardrobe if p.tipo in ['pantalón', 'jeans', 'falda']]
    shoes = [p for p in wardrobe if p.tipo in ['zapatos', 'botas', 'sandalias']]
    
    outfits = []
    
    # Generar combinaciones basadas en el modelo
    for top in tops[:3]:  # Limitar a 3 tops
        for bottom in bottoms[:2]:  # Limitar a 2 bottoms
            for shoe in shoes[:2]:  # Limitar a 2 shoes
                # Crear features para el modelo
                features = {
                    f'tipo_{top.tipo}': 1,
                    f'tipo_{bottom.tipo}': 1,
                    f'tipo_{shoe.tipo}': 1,
                    f'color_{top.color}': 1,
                    f'color_{bottom.color}': 1,
                }
                
                # Agregar temporada si está en preferencias
                if 'temporada' in preferences:
                    features[f'temporada_{preferences["temporada"]}'] = 1
                
                # Predecir grupo del outfit
                try:
                    group = predict_outfit_group(features)
                    
                    # Crear outfit
                    outfit = Outfit(
                        nombre=f"Outfit Grupo {group}",
                        prendas=[top, bottom, shoe],
                        grupo_estilo=int(group)
                    )
                    outfits.append(outfit)
                    
                    # Limitar a 5 outfits
                    if len(outfits) >= 5:
                        return outfits
                        
                except Exception as e:
                    print(f"Error al predecir outfit: {e}")
                    continue
    
    return outfits
```

---

## 📝 Checklist de Implementación

### Frontend (Flutter)
- [ ] Cambiar `localhost` por IP local en `app_constants.dart`
- [ ] Recompilar app: `flutter run -d R58N408972H`
- [ ] Verificar que se conecta al backend

### Backend (Django)
- [ ] Iniciar con `0.0.0.0:8000` en lugar de `127.0.0.1:8000`
- [ ] Verificar que el modelo `.pkl` existe
- [ ] Actualizar `recommender.py` con la función mejorada
- [ ] Probar endpoint de detección
- [ ] Probar endpoint de recomendación

### Verificación
- [ ] Celular y PC en la misma red WiFi
- [ ] Backend accesible desde celular
- [ ] Detección de prendas funciona
- [ ] Recomendaciones usan el modelo real

---

## 🧪 Pruebas

### 1. Probar Conexión al Backend

Desde el celular, abre el navegador:
```
http://TU_IP:8000/api/
```

Deberías ver la API de Django.

### 2. Probar Detección de Prendas

En la app:
1. Ve a la pestaña de Cámara
2. Selecciona una imagen
3. Presiona "Detectar"
4. Deberías ver las prendas detectadas

### 3. Probar Recomendaciones

En la app:
1. Ve a la pestaña de Recomendaciones
2. Deberías ver outfits sugeridos
3. Los outfits deben usar el modelo real (no aleatorios)

---

## 🐛 Troubleshooting

### Error: "Connection refused"
- Verifica que el backend esté corriendo
- Verifica que uses `0.0.0.0:8000`
- Verifica que el firewall no bloquee el puerto 8000

### Error: "No module named 'ultralytics'"
```bash
cd S:\styleme_back
pip install ultralytics
```

### Error: "Model file not found"
- Verifica que `yolov8n.pt` exista en `recommendations/ia/models/`
- Descarga el modelo si es necesario

### Error: "Cannot load pickle file"
- Verifica que `modelo_recomendador_outfits.pkl` exista
- Entrena el modelo en Colab si es necesario
- Verifica la versión de scikit-learn

---

## 📦 Archivos Necesarios

### Modelos de IA
```
S:\styleme_back\recommendations\ia\models\
├── yolov8n.pt                          # Modelo YOLO para detección
└── modelo_recomendador_outfits.pkl     # Modelo KMeans para recomendación
```

### Configuración
```
S:\styleme_front\lib\core\constants\app_constants.dart  # IP del backend
S:\styleme_back\recommendations\ia\recommender.py       # Lógica de recomendación
```

---

## 🎯 Próximos Pasos

1. **Cambiar IP en el frontend**
   ```bash
   cd S:\styleme_front
   # Editar app_constants.dart
   flutter run -d R58N408972H
   ```

2. **Iniciar backend correctamente**
   ```bash
   cd S:\styleme_back
   python manage.py runserver 0.0.0.0:8000
   ```

3. **Probar detección de prendas** desde la app

4. **Actualizar recommender.py** con la función mejorada

5. **Probar recomendaciones** desde la app

---

## 💡 Notas Importantes

- **IP Local:** Cambia cada vez que te conectas a una red diferente
- **Firewall:** Puede bloquear conexiones, desactívalo temporalmente para probar
- **Red WiFi:** Celular y PC deben estar en la misma red
- **Hot Reload:** Usa `r` en la terminal de Flutter para ver cambios sin recompilar

¡Listo para arreglar la IA! 🚀
