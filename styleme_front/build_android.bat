@echo off
echo ========================================
echo  StyleMe - Android Build Script
echo ========================================
echo.

REM Limpiar proyecto
echo [1/4] Limpiando proyecto...
call flutter clean
if %errorlevel% neq 0 goto error

REM Obtener dependencias
echo [2/4] Obteniendo dependencias...
call flutter pub get
if %errorlevel% neq 0 goto error

REM Crear directorio de shaders
echo [3/4] Creando directorios necesarios...
if not exist "build\app\intermediates\flutter\release\flutter_assets\shaders" (
    mkdir "build\app\intermediates\flutter\release\flutter_assets\shaders"
)

REM Compilar APK
echo [4/4] Compilando APK...
call flutter build apk --release
if %errorlevel% neq 0 goto error

echo.
echo ========================================
echo  Compilacion exitosa!
echo  APK ubicado en: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
goto end

:error
echo.
echo ========================================
echo  ERROR: La compilacion fallo
echo ========================================
exit /b 1

:end
