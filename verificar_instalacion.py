#!/usr/bin/env python
"""
Script de verificación de instalación de StyleMe Backend
Ejecutar: python verificar_instalacion.py
"""

import sys
import os

def print_header(text):
    print("\n" + "="*60)
    print(f"  {text}")
    print("="*60)

def print_check(passed, message):
    symbol = "✓" if passed else "✗"
    status = "OK" if passed else "ERROR"
    print(f"[{symbol}] {message} ... {status}")
    return passed

def verificar_instalacion():
    print_header("VERIFICACIÓN DE INSTALACIÓN - StyleMe Backend")
    
    all_passed = True
    
    # 1. Python version
    print_header("1. Verificando Python")
    python_version = sys.version_info
    passed = python_version >= (3, 8)
    all_passed &= print_check(passed, f"Python {python_version.major}.{python_version.minor}.{python_version.micro}")
    
    if not passed:
        print("   ⚠️  Se requiere Python 3.8 o superior")
    
    # 2. Django
    print_header("2. Verificando Django")
    try:
        import django
        passed = True
        all_passed &= print_check(passed, f"Django {django.get_version()}")
    except ImportError:
        all_passed &= print_check(False, "Django no instalado")
        print("   💡 Ejecuta: pip install -r requirements.txt")
    
    # 3. Django REST Framework
    print_header("3. Verificando Django REST Framework")
    try:
        import rest_framework
        passed = True
        all_passed &= print_check(passed, f"DRF {rest_framework.__version__}")
    except ImportError:
        all_passed &= print_check(False, "Django REST Framework no instalado")
    
    # 4. MongoDB
    print_header("4. Verificando MongoDB")
    try:
        from pymongo import MongoClient
        client = MongoClient('localhost', 27017, serverSelectionTimeoutMS=2000)
        client.server_info()
        passed = True
        all_passed &= print_check(passed, "MongoDB conectado en localhost:27017")
        
        # Verificar base de datos
        db_name = 'styleme_db'
        db = client[db_name]
        all_passed &= print_check(True, f"Base de datos '{db_name}' accesible")
        
        client.close()
    except Exception as e:
        all_passed &= print_check(False, f"MongoDB: {str(e)}")
        print("   💡 Asegúrate de que MongoDB esté corriendo")
        print("   Windows: net start MongoDB")
        print("   Linux: sudo systemctl start mongod")
    
    # 5. MongoEngine
    print_header("5. Verificando MongoEngine")
    try:
        import mongoengine
        passed = True
        all_passed &= print_check(passed, f"MongoEngine {mongoengine.__version__}")
    except ImportError:
        all_passed &= print_check(False, "MongoEngine no instalado")
    
    # 6. GridFS
    print_header("6. Verificando GridFS")
    try:
        from gridfs import GridFS
        passed = True
        all_passed &= print_check(passed, "GridFS disponible")
        
        # Intentar inicializar
        try:
            from recommendations.services.gridfs_service import GridFSService
            GridFSService.initialize()
            all_passed &= print_check(True, "GridFSService inicializado")
        except Exception as e:
            all_passed &= print_check(False, f"GridFSService: {str(e)}")
    except ImportError:
        all_passed &= print_check(False, "GridFS no disponible")
    
    # 7. YOLO (Ultralytics)
    print_header("7. Verificando YOLO")
    try:
        from ultralytics import YOLO
        passed = True
        all_passed &= print_check(passed, "Ultralytics YOLO instalado")
    except ImportError:
        all_passed &= print_check(False, "Ultralytics no instalado")
    
    # 8. PyTorch
    print_header("8. Verificando PyTorch")
    try:
        import torch
        passed = True
        all_passed &= print_check(passed, f"PyTorch {torch.__version__}")
    except ImportError:
        all_passed &= print_check(False, "PyTorch no instalado")
    
    # 9. OpenCV
    print_header("9. Verificando OpenCV")
    try:
        import cv2
        passed = True
        all_passed &= print_check(passed, f"OpenCV {cv2.__version__}")
    except ImportError:
        all_passed &= print_check(False, "OpenCV no instalado")
    
    # 10. scikit-learn
    print_header("10. Verificando scikit-learn")
    try:
        import sklearn
        passed = True
        all_passed &= print_check(passed, f"scikit-learn {sklearn.__version__}")
    except ImportError:
        all_passed &= print_check(False, "scikit-learn no instalado")
    
    # 11. Estructura de archivos
    print_header("11. Verificando Estructura de Archivos")
    
    required_files = [
        'manage.py',
        'requirements.txt',
        'backend/settings.py',
        'recommendations/urls.py',
        'recommendations/services/gridfs_service.py',
        'recommendations/services/imagen_service.py',
        'recommendations/services/outfit_service.py',
        'recommendations/controllers/imagen_controller.py',
        'recommendations/controllers/outfit_controller.py',
        'recommendations/ia/detector.py',
        'recommendations/ia/recommender.py',
    ]
    
    for file_path in required_files:
        exists = os.path.exists(file_path)
        all_passed &= print_check(exists, f"Archivo: {file_path}")
    
    # 12. Documentación
    print_header("12. Verificando Documentación")
    
    docs = [
        'ARQUITECTURA_MODULAR.md',
        'MONGODB_GRIDFS_SETUP.md',
        'API_CARGA_IMAGENES.md',
        'README_INSTALACION.md',
        'RESUMEN_PROYECTO.md'
    ]
    
    for doc in docs:
        exists = os.path.exists(doc)
        print_check(exists, f"Documentación: {doc}")
    
    # Resumen final
    print_header("RESUMEN")
    
    if all_passed:
        print("\n✅ ¡TODO ESTÁ CORRECTO!")
        print("\nPuedes ejecutar el servidor:")
        print("   python manage.py runserver")
        print("\nY probar el endpoint:")
        print("   curl -X POST http://localhost:8000/api/detect-clothing/ \\")
        print("     -F 'email=test@example.com' \\")
        print("     -F 'image=@foto.jpg'")
    else:
        print("\n⚠️  HAY PROBLEMAS QUE RESOLVER")
        print("\nRevisa los errores marcados con [✗] arriba")
        print("\nPasos sugeridos:")
        print("1. pip install -r requirements.txt")
        print("2. Verificar que MongoDB esté corriendo")
        print("3. Ejecutar este script nuevamente")
    
    print("\n" + "="*60)
    return all_passed

if __name__ == "__main__":
    try:
        success = verificar_instalacion()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️  Verificación cancelada por el usuario")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Error inesperado: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
