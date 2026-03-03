# 📅 Plan de Trabajo - Sprint 1

**Proyecto:** StyleMe  
**Sprint:** 1  
**Duración:** 3 semanas  
**Equipo:** 3 personas

---

## 🎯 Objetivo del Sprint

Completar las funcionalidades básicas de carga de imágenes, detección automática de prendas y generación de recomendaciones de outfits.

---

## 📋 Historias de Usuario

### SCRUM-2: Carga De Imagen Corporal Del Usuario
**Prioridad:** Media  
**Asignado a:** Persona 1 (Frontend)

### SCRUM-3: Carga De Imágenes De Guardarropa
**Prioridad:** Alta  
**Asignado a:** Persona 1 (Frontend) + Persona 2 (Frontend)

### SCRUM-4: Generador De Estilos Personalizado
**Prioridad:** Alta  
**Asignado a:** Persona 2 (Frontend) + Persona 3 (Backend)

### SCRUM-10: Etiquetado Automático de Prendas
**Prioridad:** Alta  
**Asignado a:** Persona 3 (Backend)

---

## 👥 Distribución de Tareas

### 👤 Persona 1: Frontend - Usuario e Imágenes

**Responsabilidades:**
- SCRUM-2: Carga de imagen corporal
- SCRUM-3: Carga de imágenes de guardarropa (Parte 1)

#### Semana 1: Setup y UI Básica
- [ ] Configurar proyecto Flutter
- [ ] Crear estructura de carpetas
- [ ] Configurar dependencias (http, image_picker)
- [ ] Crear modelos Dart para DTOs
- [ ] Crear servicio HTTP base

**Entregables:**
- Proyecto Flutter configurado
- Modelos Dart creados
- Servicio HTTP funcional

#### Semana 2: Carga de Imagen Corporal (SCRUM-2)
- [ ] Pantalla de perfil de usuario
- [ ] Integración con cámara/galería
- [ ] Preview de imagen seleccionada
- [ ] Validación de imagen (formato, tamaño)
- [ ] Subida al backend (endpoint futuro)

**Entregables:**
- Pantalla de perfil funcional
- Captura/selección de imagen
- Validaciones implementadas

#### Semana 3: Carga de Prendas (SCRUM-3 Parte 1)
- [ ] Pantalla de carga de prendas
- [ ] Selección múltiple de imágenes
- [ ] Integración con `/api/detect-clothing/`
- [ ] Mostrar progreso de carga
- [ ] Manejo de errores (formato, tamaño, red)
- [ ] Mostrar resultados de detección

**Entregables:**
- Pantalla de carga funcional
- Integración con API completa
- Manejo de errores robusto

---

### 👤 Persona 2: Frontend - Visualización y Recomendaciones

**Responsabilidades:**
- SCRUM-3: Visualización de guardarropa (Parte 2)
- SCRUM-4: UI de recomendaciones

#### Semana 1: Modelos y Servicios
- [ ] Crear modelos Dart (Clothing, Outfit, User)
- [ ] Crear servicio de API para outfits
- [ ] Crear servicio de API para imágenes
- [ ] Configurar provider/state management
- [ ] Crear widgets reutilizables

**Entregables:**
- Modelos completos
- Servicios de API
- Widgets base

#### Semana 2: Visualización de Guardarropa (SCRUM-3 Parte 2)
- [ ] Pantalla de guardarropa
- [ ] Grid/lista de prendas
- [ ] Mostrar imágenes desde URLs
- [ ] Filtros (tipo, color, temporada)
- [ ] Funcionalidad de editar prenda
- [ ] Funcionalidad de eliminar prenda

**Entregables:**
- Pantalla de guardarropa funcional
- Visualización de imágenes
- Filtros y acciones

#### Semana 3: Recomendaciones (SCRUM-4 Frontend)
- [ ] Pantalla de recomendaciones
- [ ] Integración con `/api/recommend/`
- [ ] Mostrar outfits generados
- [ ] Navegación entre outfits (swipe/botones)
- [ ] Botón para generar nuevos outfits
- [ ] Guardar outfits favoritos
- [ ] Compartir outfit (opcional)

**Entregables:**
- Pantalla de recomendaciones funcional
- Navegación fluida
- Integración con API

---

### 👤 Persona 3: Backend - IA y Mejoras

**Responsabilidades:**
- SCRUM-10: Etiquetado automático mejorado
- SCRUM-4: Mejorar algoritmo de recomendación

#### Semana 1: Detección de Color (SCRUM-10)
- [ ] Investigar métodos de detección de color
- [ ] Implementar extracción de color dominante (OpenCV)
- [ ] Crear función `detect_color(image_path)`
- [ ] Integrar en `imagen_service.py`
- [ ] Probar con diferentes imágenes
- [ ] Documentar método

**Entregables:**
- Función de detección de color
- Integración en servicio
- Tests básicos

**Código esperado:**
```python
# ia/color_detector.py
def detect_dominant_color(image_path):
    # Usar K-means para encontrar color dominante
    # Retornar nombre del color (ej: "azul", "rojo")
    pass
```

#### Semana 2: Clasificación de Temporada (SCRUM-10)
- [ ] Definir reglas de clasificación
- [ ] Implementar clasificador de temporada
- [ ] Crear función `classify_season(tipo, color)`
- [ ] Integrar en `imagen_service.py`
- [ ] Probar clasificación
- [ ] Documentar reglas

**Entregables:**
- Clasificador de temporada
- Integración en servicio
- Documentación de reglas

**Código esperado:**
```python
# ia/season_classifier.py
def classify_season(tipo, color, material=None):
    # Reglas basadas en tipo y color
    # Retornar temporada (verano, invierno, etc)
    pass
```

#### Semana 3: Mejorar Recomendaciones (SCRUM-4)
- [ ] Analizar algoritmo actual
- [ ] Implementar reglas de combinación de colores
- [ ] Mejorar filtrado por preferencias
- [ ] Agregar filtros por ocasión
- [ ] Crear endpoint para filtros
- [ ] Mejorar modelo KMeans con más datos
- [ ] Documentar mejoras

**Entregables:**
- Algoritmo mejorado
- Nuevos endpoints (si necesario)
- Documentación actualizada

**Endpoints nuevos:**
```python
# Filtrar por ocasión
POST /api/recommend-by-occasion/
{
  "email": "user@example.com",
  "occasion": "casual" | "formal" | "deportivo"
}

# Filtrar por clima
POST /api/recommend-by-weather/
{
  "email": "user@example.com",
  "weather": "caluroso" | "frio" | "lluvioso"
}
```

---

## 📊 Métricas de Éxito

### Persona 1
- [ ] 100% de pantallas implementadas (2/2)
- [ ] Integración con API funcional
- [ ] Manejo de errores completo
- [ ] Validaciones implementadas

### Persona 2
- [ ] 100% de pantallas implementadas (2/2)
- [ ] Visualización de imágenes funcional
- [ ] Navegación fluida
- [ ] State management implementado

### Persona 3
- [ ] Detección de color con >70% precisión
- [ ] Clasificación de temporada implementada
- [ ] Algoritmo de recomendación mejorado
- [ ] Documentación actualizada

---

## 🗓️ Calendario

### Semana 1 (08-14 Oct)
**Lunes-Martes:** Setup y configuración  
**Miércoles-Jueves:** Desarrollo inicial  
**Viernes:** Review y ajustes  
**Fin de semana:** Testing individual

### Semana 2 (15-21 Oct)
**Lunes-Martes:** Desarrollo de funcionalidades principales  
**Miércoles-Jueves:** Integración  
**Viernes:** Review y ajustes  
**Fin de semana:** Testing de integración

### Semana 3 (22-28 Oct)
**Lunes-Miércoles:** Completar funcionalidades  
**Jueves:** Testing completo  
**Viernes:** Demo y retrospectiva  

---

## 🤝 Reuniones

### Daily Standup (10 min)
**Horario:** Todos los días a las 9:00 AM  
**Formato:**
1. ¿Qué hice ayer?
2. ¿Qué haré hoy?
3. ¿Tengo algún bloqueador?

### Sprint Planning (2 horas)
**Fecha:** Lunes 08 Oct, 10:00 AM  
**Agenda:**
1. Revisar historias de usuario
2. Estimar tareas
3. Asignar responsabilidades
4. Definir Definition of Done

### Sprint Review (1 hora)
**Fecha:** Viernes 26 Oct, 3:00 PM  
**Agenda:**
1. Demo de funcionalidades
2. Feedback del equipo
3. Validar criterios de aceptación

### Sprint Retrospective (1 hora)
**Fecha:** Viernes 26 Oct, 4:00 PM  
**Agenda:**
1. ¿Qué salió bien?
2. ¿Qué podemos mejorar?
3. Acciones para el próximo sprint

---

## 🔧 Herramientas

### Comunicación
- **WhatsApp/Telegram:** Comunicación diaria
- **Google Meet:** Reuniones virtuales
- **Discord:** Pair programming

### Gestión
- **Jira/Trello:** Seguimiento de tareas
- **GitHub:** Control de versiones
- **Google Drive:** Documentación compartida

### Desarrollo
- **VS Code:** Editor de código
- **Postman:** Testing de API
- **MongoDB Compass:** Visualización de BD
- **Flutter DevTools:** Debug de Flutter

---

## 📝 Definition of Done

Una tarea está "Done" cuando:

- [ ] Código implementado y funcional
- [ ] Tests básicos pasando
- [ ] Code review completado
- [ ] Documentación actualizada
- [ ] Integrado en rama principal
- [ ] Demo funcional
- [ ] Sin bugs críticos

---

## 🚨 Riesgos y Mitigación

### Riesgo 1: Problemas de integración API
**Probabilidad:** Media  
**Impacto:** Alto  
**Mitigación:**
- Documentación clara de API
- Postman collections compartidas
- Testing temprano de integración

### Riesgo 2: Precisión de detección YOLO baja
**Probabilidad:** Media  
**Impacto:** Medio  
**Mitigación:**
- Usar imágenes de calidad
- Ajustar threshold de confianza
- Permitir edición manual

### Riesgo 3: Retrasos en desarrollo
**Probabilidad:** Media  
**Impacto:** Alto  
**Mitigación:**
- Buffer de tiempo en estimaciones
- Priorizar funcionalidades core
- Pair programming cuando sea necesario

### Riesgo 4: Problemas de rendimiento
**Probabilidad:** Baja  
**Impacto:** Medio  
**Mitigación:**
- Optimizar imágenes antes de subir
- Usar loading states
- Implementar caché

---

## 📦 Entregables Finales del Sprint

### Frontend
1. App Flutter funcional con:
   - Carga de imagen corporal
   - Carga de prendas
   - Visualización de guardarropa
   - Recomendaciones de outfits

2. Integración completa con API

3. Manejo de errores robusto

### Backend
1. Detección de color implementada
2. Clasificación de temporada
3. Algoritmo de recomendación mejorado
4. Documentación actualizada

### General
1. Demo funcional end-to-end
2. Documentación de usuario
3. Reporte de bugs conocidos
4. Plan para Sprint 2

---

## 🎯 Objetivos Específicos por Persona

### Persona 1
**Objetivo:** Usuario puede cargar imágenes de prendas exitosamente

**Criterios:**
- Selección de múltiples imágenes
- Validación de formato y tamaño
- Integración con API
- Feedback visual claro

### Persona 2
**Objetivo:** Usuario puede ver su guardarropa y recibir recomendaciones

**Criterios:**
- Visualización de todas las prendas
- Filtros funcionales
- Recomendaciones visuales atractivas
- Navegación intuitiva

### Persona 3
**Objetivo:** Sistema detecta y clasifica prendas automáticamente con precisión

**Criterios:**
- Detección de color >70% precisión
- Clasificación de temporada lógica
- Recomendaciones relevantes
- Documentación clara

---

## 📚 Recursos

### Documentación
- [ARQUITECTURA_MODULAR.md](./ARQUITECTURA_MODULAR.md)
- [API_CARGA_IMAGENES.md](./API_CARGA_IMAGENES.md)
- [MONGODB_GRIDFS_SETUP.md](./MONGODB_GRIDFS_SETUP.md)
- [COMANDOS_UTILES.md](./COMANDOS_UTILES.md)

### Tutoriales
- Flutter Image Picker: https://pub.dev/packages/image_picker
- Flutter HTTP: https://pub.dev/packages/http
- OpenCV Python: https://docs.opencv.org/
- MongoDB GridFS: https://www.mongodb.com/docs/manual/core/gridfs/

---

## ✅ Checklist de Inicio

Antes de empezar el sprint, verificar:

- [ ] Todos tienen acceso al repositorio
- [ ] Entorno de desarrollo configurado
- [ ] MongoDB corriendo
- [ ] Backend funcionando
- [ ] Documentación leída
- [ ] Tareas asignadas en Jira/Trello
- [ ] Canales de comunicación activos

---

**¡Éxito en el Sprint 1! 🚀**

**Última actualización:** 08 de Octubre, 2025
