@echo off
echo ========================================
echo  StyleMe - Ejecutar en Dispositivo
echo ========================================
echo.

REM Verificar dispositivo conectado
echo Verificando dispositivos conectados...
flutter devices
echo.

REM Preguntar por el ID del dispositivo
set /p DEVICE_ID="Ingresa el ID del dispositivo (o presiona Enter para R58N408972H): "
if "%DEVICE_ID%"=="" set DEVICE_ID=R58N408972H

echo.
echo Ejecutando en dispositivo: %DEVICE_ID%
echo.

REM Ejecutar app
flutter run -d %DEVICE_ID%
