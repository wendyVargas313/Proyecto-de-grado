"""
Script de prueba para verificar la carga de imágenes del guardarropa.
Fecha: 08 de Octubre, 2025
"""

import requests
import json
from pathlib import Path

# Configuración
API_URL = "http://localhost:8000/api/detect-clothing/"
TEST_EMAIL = "test@example.com"

def test_carga_imagen():
    """
    Prueba completa del endpoint de carga de imágenes.
    """
    print("=" * 60)
    print("🧪 PRUEBA DE CARGA DE IMÁGENES - STYLEME BACKEND")
    print("=" * 60)
    print()
    
    # Verificar que el servidor esté corriendo
    print("📡 Verificando conexión con el servidor...")
    try:
        response = requests.get("http://localhost:8000/")
        print("✅ Servidor accesible")
    except requests.exceptions.ConnectionError:
        print("❌ ERROR: El servidor no está corriendo")
        print("   Ejecuta: python manage.py runserver")
        return
    print()
    
    # Buscar imágenes de prueba
    print("🔍 Buscando imágenes de prueba...")
    image_extensions = ['.jpg', '.jpeg', '.png']
    test_images = []
    
    # Buscar en el directorio actual y subdirectorios comunes
    search_paths = [
        Path('.'),
        Path('test_images'),
        Path('media'),
        Path('recommendations/media'),
    ]
    
    for search_path in search_paths:
        if search_path.exists():
            for ext in image_extensions:
                found = list(search_path.glob(f'*{ext}'))
                test_images.extend(found)
                if len(test_images) >= 3:
                    break
        if len(test_images) >= 1:
            break
    
    if not test_images:
        print("⚠️  No se encontraron imágenes de prueba")
        print("   Por favor, coloca una imagen JPG o PNG en el directorio actual")
        print()
        print("💡 Para continuar con la prueba, ingresa la ruta de una imagen:")
        image_path = input("   Ruta: ").strip()
        if image_path and Path(image_path).exists():
            test_images = [Path(image_path)]
        else:
            print("❌ Imagen no encontrada. Prueba cancelada.")
            return
    else:
        print(f"✅ Se encontraron {len(test_images)} imagen(es)")
        for img in test_images[:3]:
            print(f"   - {img.name}")
    print()
    
    # Prueba 1: Una imagen
    print("=" * 60)
    print("TEST 1: Subir UNA imagen")
    print("=" * 60)
    
    test_image = test_images[0]
    print(f"📤 Subiendo: {test_image.name}")
    print(f"📧 Email: {TEST_EMAIL}")
    
    try:
        with open(test_image, 'rb') as img_file:
            files = {'image': img_file}
            data = {'email': TEST_EMAIL}
            
            response = requests.post(API_URL, files=files, data=data)
            
        print(f"📥 Respuesta HTTP: {response.status_code}")
        print()
        
        # Mostrar respuesta
        try:
            response_data = response.json()
            print("📋 Respuesta del servidor:")
            print(json.dumps(response_data, indent=2, ensure_ascii=False))
            print()
            
            if response.status_code == 200 and response_data.get('success'):
                print("✅ TEST 1 EXITOSO")
                print(f"   ✓ Prendas detectadas: {response_data.get('total_prendas_detectadas', 0)}")
                
                # Mostrar prendas
                prendas = response_data.get('prendas', [])
                if prendas:
                    print("\n   📦 Detalles de prendas:")
                    for i, prenda in enumerate(prendas, 1):
                        print(f"\n   Prenda {i}:")
                        print(f"      - Tipo: {prenda.get('tipo', 'N/A')}")
                        print(f"      - Confianza: {prenda.get('confianza', 'N/A')}")
                        print(f"      - URL: {prenda.get('imagen_url', 'N/A')}")
                        if prenda.get('imagen_id'):
                            print(f"      - ID GridFS: {prenda.get('imagen_id')}")
            else:
                print("❌ TEST 1 FALLÓ")
                print(f"   Error: {response_data.get('error', 'Desconocido')}")
                print(f"   Tipo: {response_data.get('error_type', 'N/A')}")
                
        except json.JSONDecodeError:
            print("❌ Error al parsear respuesta JSON")
            print(f"Respuesta raw: {response.text[:500]}")
            
    except FileNotFoundError:
        print(f"❌ Archivo no encontrado: {test_image}")
    except Exception as e:
        print(f"❌ Error inesperado: {str(e)}")
    
    print()
    
    # Prueba 2: Múltiples imágenes (si hay más de una)
    if len(test_images) > 1:
        print("=" * 60)
        print("TEST 2: Subir MÚLTIPLES imágenes")
        print("=" * 60)
        
        images_to_upload = test_images[:3]  # Máximo 3 imágenes
        print(f"📤 Subiendo {len(images_to_upload)} imágenes:")
        for img in images_to_upload:
            print(f"   - {img.name}")
        print(f"📧 Email: {TEST_EMAIL}")
        
        try:
            files = []
            for img_path in images_to_upload:
                files.append(('images', open(img_path, 'rb')))
            
            data = {'email': TEST_EMAIL}
            
            response = requests.post(API_URL, files=files, data=data)
            
            # Cerrar archivos
            for _, f in files:
                f.close()
            
            print(f"📥 Respuesta HTTP: {response.status_code}")
            print()
            
            response_data = response.json()
            print("📋 Respuesta del servidor:")
            print(json.dumps(response_data, indent=2, ensure_ascii=False))
            print()
            
            if response.status_code == 200 and response_data.get('success'):
                print("✅ TEST 2 EXITOSO")
                print(f"   ✓ Imágenes procesadas: {response_data.get('processed_images', 0)}/{response_data.get('total_images', 0)}")
                print(f"   ✓ Prendas detectadas: {response_data.get('total_prendas_detectadas', 0)}")
            else:
                print("❌ TEST 2 FALLÓ")
                
        except Exception as e:
            print(f"❌ Error: {str(e)}")
        
        print()
    
    # Instrucciones adicionales
    print("=" * 60)
    print("📚 PASOS ADICIONALES PARA VERIFICAR")
    print("=" * 60)
    print()
    print("1. Verificar en MongoDB:")
    print("   mongosh")
    print("   use styleme_db")
    print(f"   db.usuarios.findOne({{correo: '{TEST_EMAIL}'}})")
    print()
    print("2. Verificar imágenes en GridFS:")
    print(f"   db.fs.files.find({{\"metadata.user_email\": \"{TEST_EMAIL}\"}}).pretty()")
    print()
    print("3. Ver imagen en el navegador:")
    if 'response_data' in locals() and response_data.get('prendas'):
        imagen_url = response_data['prendas'][0].get('imagen_url')
        if imagen_url:
            print(f"   http://localhost:8000{imagen_url}")
    print()
    print("4. Ver logs del servidor:")
    print("   Get-Content logs\\django.log -Wait")
    print()
    print("=" * 60)
    print("✨ Prueba completada")
    print("=" * 60)


if __name__ == "__main__":
    test_carga_imagen()
