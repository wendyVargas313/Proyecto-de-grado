@echo off
title StyleMe - Configurar IP para Celular
color 0B

cls
echo ========================================
echo    STYLEME - CONFIGURACION DE IP
echo ========================================
echo.
echo Este script te ayudara a configurar
echo la IP del backend para usar la app
echo desde tu celular.
echo.
echo ========================================
echo.

echo [1/3] Obteniendo tu IP local...
echo.

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    goto :found
)

:found
set IP=%IP:~1%
echo Tu IP local es: %IP%
echo.

echo ========================================
echo [2/3] INSTRUCCIONES
echo ========================================
echo.
echo 1. Abre el archivo:
echo    S:\styleme_front\lib\core\constants\app_constants.dart
echo.
echo 2. Busca la linea:
echo    static const String baseUrl = 'http://localhost:8000/api';
echo.
echo 3. Cambiala por:
echo    static const String baseUrl = 'http://%IP%:8000/api';
echo.
echo 4. Guarda el archivo
echo.
echo 5. En la terminal de Flutter, presiona 'r' para hot reload
echo    (o recompila con: flutter run -d R58N408972H)
echo.

echo ========================================
echo [3/3] INICIAR BACKEND
echo ========================================
echo.
echo Despues de cambiar la IP, inicia el backend con:
echo.
echo    cd S:\styleme_back
echo    python manage.py runserver 0.0.0.0:8000
echo.
echo IMPORTANTE: Usa 0.0.0.0:8000 (no 127.0.0.1:8000)
echo.

echo ========================================
echo.
set /p continuar="Presiona Enter para abrir el archivo app_constants.dart..."

start notepad "S:\styleme_front\lib\core\constants\app_constants.dart"

echo.
echo Archivo abierto en Notepad.
echo Recuerda cambiar 'localhost' por '%IP%'
echo.
pause
