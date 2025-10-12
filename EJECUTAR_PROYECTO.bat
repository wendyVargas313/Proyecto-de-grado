@echo off
echo ========================================
echo    STYLEME - Ejecutar Proyecto
echo ========================================
echo.

echo Selecciona una opcion:
echo.
echo 1. Ejecutar BACKEND (Django)
echo 2. Ejecutar FRONTEND (Flutter)
echo 3. Ejecutar AMBOS (Backend + Frontend)
echo 4. Crear usuario de prueba
echo 5. Verificar instalacion
echo 6. Salir
echo.

set /p opcion="Ingresa el numero de opcion: "

if "%opcion%"=="1" goto backend
if "%opcion%"=="2" goto frontend
if "%opcion%"=="3" goto ambos
if "%opcion%"=="4" goto usuario
if "%opcion%"=="5" goto verificar
if "%opcion%"=="6" goto salir

echo Opcion invalida
pause
exit

:backend
echo.
echo ========================================
echo    Iniciando BACKEND
echo ========================================
echo.
cd styleme_back
echo Activando entorno virtual...
call env\Scripts\activate
echo.
echo Iniciando MongoDB...
net start MongoDB
echo.
echo Iniciando servidor Django...
python manage.py runserver
pause
exit

:frontend
echo.
echo ========================================
echo    Iniciando FRONTEND
echo ========================================
echo.
cd styleme_front
echo.
echo Instalando dependencias...
call flutter pub get
echo.
echo Ejecutando aplicacion en Chrome...
call flutter run -d chrome
pause
exit

:ambos
echo.
echo ========================================
echo    Iniciando BACKEND Y FRONTEND
echo ========================================
echo.
echo IMPORTANTE: Se abriran 2 ventanas
echo - Ventana 1: Backend (Django)
echo - Ventana 2: Frontend (Flutter)
echo.
pause

echo Iniciando Backend...
start cmd /k "cd styleme_back && env\Scripts\activate && net start MongoDB && python manage.py runserver"

timeout /t 3 /nobreak > nul

echo Iniciando Frontend...
start cmd /k "cd styleme_front && flutter pub get && flutter run -d chrome"

echo.
echo Proyecto iniciado!
echo.
pause
exit

:usuario
echo.
echo ========================================
echo    Crear Usuario de Prueba
echo ========================================
echo.
cd styleme_back
call env\Scripts\activate
python crear_usuario_prueba.py
pause
exit

:verificar
echo.
echo ========================================
echo    Verificar Instalacion
echo ========================================
echo.
echo Verificando Python...
python --version
echo.
echo Verificando Flutter...
flutter --version
echo.
echo Verificando MongoDB...
mongosh --eval "db.runCommand({ping: 1})"
echo.
echo Verificando Backend...
cd styleme_back
if exist env\Scripts\activate (
    echo [OK] Entorno virtual encontrado
) else (
    echo [ERROR] Entorno virtual no encontrado
)
echo.
echo Verificando Frontend...
cd ..\styleme_front
if exist pubspec.yaml (
    echo [OK] Proyecto Flutter encontrado
) else (
    echo [ERROR] Proyecto Flutter no encontrado
)
echo.
pause
exit

:salir
echo.
echo Saliendo...
exit
