"""
Script para crear usuario de prueba en MongoDB.
Fecha: 08 de Octubre, 2025
"""

from mongoengine import connect
from recommendations.entity.user import Usuario

def crear_usuario_prueba():
    """
    Crea un usuario de prueba en la base de datos.
    """
    print("=" * 60)
    print("📝 CREAR USUARIO DE PRUEBA")
    print("=" * 60)
    print()
    
    # Conectar a MongoDB
    try:
        print("🔌 Conectando a MongoDB...")
        connect(db='styleme_db', host='localhost', port=27017)
        print("✅ Conectado a MongoDB")
    except Exception as e:
        print(f"❌ Error al conectar a MongoDB: {e}")
        print("   Asegúrate de que MongoDB esté corriendo:")
        print("   net start MongoDB")
        return
    print()
    
    # Email del usuario
    email = "test@example.com"
    
    # Verificar si ya existe
    print(f"🔍 Verificando si el usuario {email} ya existe...")
    usuario_existente = Usuario.objects(correo=email).first()
    
    if usuario_existente:
        print(f"⚠️  El usuario {email} ya existe")
        print()
        print("Opciones:")
        print("1. Usar el usuario existente")
        print("2. Eliminar y crear uno nuevo")
        print("3. Salir")
        print()
        
        opcion = input("Selecciona una opción (1/2/3): ").strip()
        
        if opcion == "1":
            print()
            print("✅ Usando usuario existente")
            print()
            print("📋 Información del usuario:")
            print(f"   - Nombre: {usuario_existente.nombre}")
            print(f"   - Correo: {usuario_existente.correo}")
            print(f"   - Prendas en guardarropa: {len(usuario_existente.guardarropa)}")
            print(f"   - Outfits generados: {len(usuario_existente.outfits_generados)}")
            return
        elif opcion == "2":
            print()
            print("🗑️  Eliminando usuario existente...")
            usuario_existente.delete()
            print("✅ Usuario eliminado")
        elif opcion == "3":
            print()
            print("👋 Saliendo...")
            return
        else:
            print()
            print("❌ Opción inválida. Saliendo...")
            return
    
    print()
    
    # Crear usuario
    print("👤 Creando usuario de prueba...")
    
    try:
        usuario = Usuario(
            nombre="Usuario Test",
            correo=email,
            preferencias_color=["azul", "negro", "blanco"],
            preferencias_tipo=["casual", "deportivo"],
            preferencias_temporada=["verano", "primavera"],
            guardarropa=[],
            outfits_generados=[]
        )
        
        usuario.save()
        
        print("✅ Usuario creado exitosamente")
        print()
        print("📋 Información del usuario:")
        print(f"   - Nombre: {usuario.nombre}")
        print(f"   - Correo: {usuario.correo}")
        print(f"   - Preferencias de color: {', '.join(usuario.preferencias_color)}")
        print(f"   - Preferencias de tipo: {', '.join(usuario.preferencias_tipo)}")
        print(f"   - Preferencias de temporada: {', '.join(usuario.preferencias_temporada)}")
        print()
        print("=" * 60)
        print("✨ Usuario listo para usar")
        print("=" * 60)
        print()
        print("Ahora puedes probar el endpoint con:")
        print(f"  curl -X POST http://localhost:8000/api/detect-clothing/ \\")
        print(f"    -F \"email={email}\" \\")
        print(f"    -F \"image=@tu_imagen.jpg\"")
        print()
        
    except Exception as e:
        print(f"❌ Error al crear usuario: {e}")
        print()


def listar_usuarios():
    """
    Lista todos los usuarios en la base de datos.
    """
    print("=" * 60)
    print("👥 LISTADO DE USUARIOS")
    print("=" * 60)
    print()
    
    try:
        connect(db='styleme_db', host='localhost', port=27017)
        
        usuarios = Usuario.objects()
        
        if not usuarios:
            print("⚠️  No hay usuarios en la base de datos")
            print()
            return
        
        print(f"Total de usuarios: {len(usuarios)}")
        print()
        
        for i, usuario in enumerate(usuarios, 1):
            print(f"{i}. {usuario.nombre}")
            print(f"   📧 Email: {usuario.correo}")
            print(f"   👔 Prendas: {len(usuario.guardarropa)}")
            print(f"   👗 Outfits: {len(usuario.outfits_generados)}")
            print()
        
    except Exception as e:
        print(f"❌ Error: {e}")
        print()


def menu():
    """
    Menú principal.
    """
    print()
    print("=" * 60)
    print("     GESTIÓN DE USUARIOS DE PRUEBA - STYLEME")
    print("=" * 60)
    print()
    print("Opciones:")
    print("1. Crear usuario de prueba")
    print("2. Listar usuarios")
    print("3. Salir")
    print()
    
    opcion = input("Selecciona una opción (1/2/3): ").strip()
    
    if opcion == "1":
        print()
        crear_usuario_prueba()
    elif opcion == "2":
        print()
        listar_usuarios()
    elif opcion == "3":
        print()
        print("👋 ¡Hasta luego!")
        print()
        return
    else:
        print()
        print("❌ Opción inválida")
        print()


if __name__ == "__main__":
    menu()
