import os

# 1. auth_service.dart - mismo directorio que storage_service
with open('lib/services/auth_service.dart', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
content = content.replace(
    "import 'package:styleme_front/services/storage_service.dart';",
    "import 'storage_service.dart';"
)
# Arreglar uso de instancia a estatico
content = content.replace(
    "  final StorageService _storage = StorageService();",
    ""
)
content = content.replace(
    "await _storage.saveToken(", "await StorageService.saveToken("
)
content = content.replace(
    "await _storage.saveUser(", "await StorageService.saveUser("
)
content = content.replace(
    "await _storage.clearAll()", "await StorageService.clearAll()"
)
content = content.replace(
    "await _storage.getToken()", "await StorageService.getToken()"
)
content = content.replace(
    "return await _storage.getUser()", "return await StorageService.getUser()"
)
with open('lib/services/auth_service.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('1. auth_service.dart corregido')

# 2. user_provider.dart
with open('lib/providers/user_provider.dart', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
content = content.replace(
    "import 'package:styleme_front/services/storage_service.dart';",
    "import '../services/storage_service.dart';"
)
with open('lib/providers/user_provider.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('2. user_provider.dart corregido')

# 3. onboarding_screen.dart
with open('lib/ui/screens/onboarding_screen.dart', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
content = content.replace(
    "import 'package:styleme_front/services/storage_service.dart';",
    "import '../../services/storage_service.dart';"
)
with open('lib/ui/screens/onboarding_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('3. onboarding_screen.dart corregido')

# 4. app_routes.dart
with open('lib/routes/app_routes.dart', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
content = content.replace(
    "import 'package:styleme_front/ui/screens/splash_screen.dart';",
    "import '../ui/screens/splash_screen.dart';"
)
content = content.replace(
    "import 'package:styleme_front/ui/screens/login_screen.dart';",
    "import '../ui/screens/login_screen.dart';"
)
with open('lib/routes/app_routes.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('4. app_routes.dart corregido')

# 5. main.dart - agregar import de storage_service de vuelta
with open('lib/main.dart', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
if "import 'services/storage_service.dart';" not in content:
    content = content.replace(
        "import 'core/constants/app_colors.dart';",
        "import 'core/constants/app_colors.dart';\nimport 'services/storage_service.dart';"
    )
if "await StorageService.init();" not in content:
    content = content.replace(
        "  WidgetsFlutterBinding.ensureInitialized();",
        "  WidgetsFlutterBinding.ensureInitialized();\n  await StorageService.init();"
    )
with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('5. main.dart corregido')

print('\nListo!')
