# Arquitectura Modular - StyleMe Backend

## 📋 Descripción General

El backend de StyleMe ha sido refactorizado siguiendo una **arquitectura modular en capas** que separa las responsabilidades y facilita el mantenimiento, testing y escalabilidad del código.

## 🏗️ Estructura de Capas

```
┌─────────────────────────────────────┐
│         Controllers                 │  ← Capa de Presentación
│  (Manejo de HTTP requests/responses)│
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│           Services                  │  ← Capa de Lógica de Negocio
│   (Orquestación y reglas de negocio)│
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│         Repositories                │  ← Capa de Acceso a Datos
│    (Operaciones CRUD en MongoDB)    │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│          Entities                   │  ← Capa de Modelo de Datos
│    (Modelos de MongoDB/MongoEngine) │
└─────────────────────────────────────┘

         DTOs (Data Transfer Objects)
    ↔ Transferencia entre capas ↔
```

## 📁 Estructura de Directorios

```
styleme_back/recommendations/
├── controllers/          # Endpoints HTTP (API REST)
│   ├── outfit_controller.py
│   └── imagen_controller.py
│
├── services/            # Lógica de negocio
│   ├── outfit_service.py
│   ├── imagen_service.py
│   └── user_service.py
│
├── repository/          # Acceso a datos
│   ├── user_repository.py
│   └── outfit_repository.py
│
├── dto/                 # Data Transfer Objects
│   ├── clothing_dto.py
│   ├── outfit_dto.py
│   └── user_dto.py
│
├── entity/              # Modelos de MongoDB
│   ├── user.py
│   ├── clothing.py
│   └── outfit.py
│
└── ia/                  # Módulos de IA
    ├── detector.py      # YOLO para detección
    └── recommender.py   # KMeans para recomendación
```

## 🔄 Flujo de Datos

### Ejemplo: Generar Outfits

```
1. Cliente → POST /api/recommend/ {"email": "user@example.com"}
                    ↓
2. Controller (outfit_controller.py)
   - Recibe request
   - Crea OutfitRecommendationRequestDTO
   - Valida datos básicos
                    ↓
3. Service (outfit_service.py)
   - Valida lógica de negocio
   - Obtiene usuario del repository
   - Genera outfits con IA
   - Guarda resultados
                    ↓
4. Repository (user_repository.py)
   - Busca usuario en MongoDB
   - Guarda outfits generados
                    ↓
5. Entity (user.py, outfit.py)
   - Modelos de datos de MongoDB
                    ↓
6. Controller → Response con OutfitDTOs
```

## 📦 Componentes Principales

### 1. DTOs (Data Transfer Objects)

**Propósito:** Validar y transferir datos entre capas sin exponer entidades de base de datos.

**Archivos:**
- `clothing_dto.py`: ClothingDTO, ClothingDetectionDTO
- `outfit_dto.py`: OutfitDTO, OutfitRecommendationRequestDTO, OutfitAIRequestDTO
- `user_dto.py`: UserDTO, UserPreferencesDTO, ImageUploadRequestDTO

**Ejemplo:**
```python
@dataclass
class ClothingDTO:
    tipo: str
    color: str
    temporada: str
    
    def to_dict(self):
        return {...}
    
    @staticmethod
    def from_entity(prenda):
        return ClothingDTO(...)
```

### 2. Repositories

**Propósito:** Encapsular todas las operaciones de acceso a datos (CRUD).

**Archivos:**
- `user_repository.py`: Operaciones sobre usuarios
- `outfit_repository.py`: Operaciones sobre outfits

**Métodos principales:**
```python
class UserRepository:
    @staticmethod
    def find_by_email(email: str) -> Optional[Usuario]
    
    @staticmethod
    def save(user: Usuario) -> Usuario
    
    @staticmethod
    def add_clothing_to_wardrobe(user, prendas) -> Usuario
```

### 3. Services

**Propósito:** Contener la lógica de negocio y orquestar operaciones entre repositories.

**Archivos:**
- `outfit_service.py`: Generación y predicción de outfits
- `imagen_service.py`: Detección de prendas en imágenes
- `user_service.py`: Gestión de usuarios

**Métodos principales:**
```python
class OutfitService:
    def generate_outfits_for_user(self, email: str) -> List[OutfitDTO]
    
    def predict_outfit_group_ai(self, features: Dict) -> int
    
    def validate_outfit_combination(self, prendas: List) -> bool
```

### 4. Controllers

**Propósito:** Manejar requests HTTP, validar entrada básica y devolver responses.

**Características:**
- Ligeros y enfocados en HTTP
- Delegan lógica a Services
- Manejan errores y status codes
- Usan DTOs para validación

**Ejemplo:**
```python
@api_view(['POST'])
def recommend_outfit(request):
    try:
        request_dto = OutfitRecommendationRequestDTO.from_request(request.data)
        request_dto.validate()
        
        outfits = outfit_service.generate_outfits_for_user(request_dto.email)
        
        return Response({"outfits": [...]}, status=200)
    except ValueError as e:
        return Response({"error": str(e)}, status=400)
```

## ✅ Ventajas de esta Arquitectura

### 1. **Separación de Responsabilidades**
- Cada capa tiene una función específica
- Fácil de entender y mantener

### 2. **Reutilización de Código**
- Services y Repositories pueden usarse en múltiples controllers
- DTOs reutilizables en diferentes contextos

### 3. **Testeable**
- Cada capa puede testearse independientemente
- Fácil crear mocks de repositories y services

### 4. **Escalable**
- Agregar nuevas funcionalidades es sencillo
- Cambiar implementación de una capa no afecta otras

### 5. **Mantenible**
- Código organizado y predecible
- Fácil localizar bugs
- Documentación clara

## 🔧 Cómo Agregar Nueva Funcionalidad

### Ejemplo: Agregar endpoint para eliminar prenda

1. **Crear DTO** (si es necesario)
```python
# dto/clothing_dto.py
@dataclass
class DeleteClothingRequestDTO:
    email: str
    prenda_id: str
```

2. **Agregar método en Repository**
```python
# repository/user_repository.py
@staticmethod
def remove_clothing_from_wardrobe(user, prenda_id):
    user.guardarropa = [p for p in user.guardarropa if p.id != prenda_id]
    user.save()
    return user
```

3. **Agregar método en Service**
```python
# services/user_service.py
def delete_clothing(self, email: str, prenda_id: str):
    user = self.user_repository.find_by_email(email)
    if not user:
        raise ValueError("Usuario no encontrado")
    
    return self.user_repository.remove_clothing_from_wardrobe(user, prenda_id)
```

4. **Crear endpoint en Controller**
```python
# controllers/clothing_controller.py
@api_view(['DELETE'])
def delete_clothing(request):
    try:
        request_dto = DeleteClothingRequestDTO.from_request(request.data)
        user_service.delete_clothing(request_dto.email, request_dto.prenda_id)
        return Response({"message": "Prenda eliminada"}, status=200)
    except ValueError as e:
        return Response({"error": str(e)}, status=400)
```

5. **Registrar URL**
```python
# urls.py
urlpatterns = [
    path('clothing/delete/', delete_clothing),
]
```

## 📚 Buenas Prácticas

### 1. Controllers
- ✅ Mantenerlos ligeros (< 50 líneas)
- ✅ Solo validación básica de HTTP
- ✅ Delegar lógica a Services
- ❌ No acceder directamente a Entities o Repositories

### 2. Services
- ✅ Contener toda la lógica de negocio
- ✅ Validar reglas de negocio
- ✅ Orquestar múltiples repositories
- ❌ No manejar requests/responses HTTP

### 3. Repositories
- ✅ Solo operaciones de datos (CRUD)
- ✅ Métodos reutilizables y atómicos
- ❌ No incluir lógica de negocio

### 4. DTOs
- ✅ Validar datos de entrada
- ✅ Transformar entre formatos
- ✅ Documentar campos requeridos
- ❌ No incluir lógica de negocio

## 🧪 Testing

La arquitectura modular facilita el testing:

```python
# Ejemplo de test para Service
def test_generate_outfits_for_user():
    # Mock del repository
    mock_repo = Mock(UserRepository)
    mock_repo.find_by_email.return_value = mock_user
    
    # Test del service
    service = OutfitService()
    service.user_repository = mock_repo
    
    outfits = service.generate_outfits_for_user("test@example.com")
    
    assert len(outfits) > 0
    assert isinstance(outfits[0], OutfitDTO)
```

## 📝 Notas Adicionales

- Los módulos de IA (`ia/detector.py`, `ia/recommender.py`) se mantienen separados y son llamados desde Services
- MongoDB se accede únicamente a través de Repositories
- Los DTOs incluyen métodos `to_dict()` y `from_entity()` para conversión
- Todos los errores de validación lanzan `ValueError` que son capturados en Controllers

## 🚀 Próximos Pasos Recomendados

1. Agregar tests unitarios para cada capa
2. Implementar logging en Services
3. Agregar paginación en endpoints que retornan listas
4. Implementar caché para consultas frecuentes
5. Agregar autenticación y autorización
6. Documentar API con Swagger/OpenAPI
