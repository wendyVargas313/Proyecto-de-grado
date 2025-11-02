@echo off
title StyleMe - Launcher
color 0A

:menu
cls
echo ========================================
echo          STYLEME - LAUNCHER
echo ========================================
echo.
echo 1. Ejecutar en Celular (Debug)
echo 2. Compilar APK Release
echo 3. Instalar APK en Celular
echo 4. Ver Dispositivos Conectados
echo 5. Limpiar Proyecto
echo 6. Iniciar Backend
echo 7. Ver Logs
echo 8. Salir
echo.
echo ========================================
set /p option="Selecciona una opcion (1-8): "

if "%option%"=="1" goto run_debug
if "%option%"=="2" goto build_release
if "%option%"=="3" goto install_apk
if "%option%"=="4" goto show_devices
if "%option%"=="5" goto clean_project
if "%option%"=="6" goto start_backend
if "%option%"=="7" goto show_logs
if "%option%"=="8" goto end

echo Opcion invalida
pause
goto menu

:run_debug
cls
echo ========================================
echo  Ejecutando en Celular (Debug)
echo ========================================
echo.
cd S:\styleme_front
flutter run -d R58N408972H
pause
goto menu

:build_release
cls
echo ========================================
echo  Compilando APK Release
echo ========================================
echo.
cd S:\styleme_front
flutter clean
flutter pub get
flutter build apk --release
echo.
echo APK generado en: build\app\outputs\flutter-apk\app-release.apk
pause
goto menu

:install_apk
cls
echo ========================================
echo  Instalando APK en Celular
echo ========================================
echo.
cd S:\styleme_front
flutter install -d R58N408972H
pause
goto menu

:show_devices
cls
echo ========================================
echo  Dispositivos Conectados
echo ========================================
echo.
flutter devices
echo.
pause
goto menu

:clean_project
cls
echo ========================================
echo  Limpiando Proyecto
echo ========================================
echo.
cd S:\styleme_front
flutter clean
flutter pub get
echo.
echo Proyecto limpiado!
pause
goto menu

:start_backend
cls
echo ========================================
echo  Iniciando Backend Django
echo ========================================
echo.
echo IMPORTANTE: Configura la IP del backend en:
echo S:\styleme_front\lib\core\constants\app_constants.dart
echo.
echo Tu IP local (ejecuta 'ipconfig' para verla):
ipconfig | findstr /i "IPv4"
echo.
echo Presiona Ctrl+C para detener el backend
echo.
cd S:\styleme_back
python manage.py runserver 0.0.0.0:8000
pause
goto menu

:show_logs
cls
echo ========================================
echo  Logs de Flutter
echo ========================================
echo.
echo Presiona Ctrl+C para salir
echo.
flutter logs
pause
goto menu

:end
cls
echo.
echo Gracias por usar StyleMe!
echo.
timeout /t 2 >nul
exit
