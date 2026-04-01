# Script para corregir auth_service.dart
with open('lib/services/auth_service.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Corregir strings rotos con backslash al final
content = content.replace("throw Exception('Error de conexi\u00c3\u00b3n: \\');", "throw Exception('Error de conexion');")
content = content.replace("throw Exception('Error en logout: \\');", "throw Exception('Error en logout');")

# Limpiar caracteres corruptos en comentarios
content = content.replace("autenticaci\u00c3\u00b3n", "autenticacion")
content = content.replace("sesi\u00c3\u00b3n", "sesion")
content = content.replace("conexi\u00c3\u00b3n", "conexion")

with open('lib/services/auth_service.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('Listo')
