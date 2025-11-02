@echo off
title StyleMe - Flutter en Celular
color 0A

cls
echo ========================================
echo    STYLEME - EJECUTAR EN CELULAR
echo ========================================
echo.

echo Verificando dispositivo conectado...
flutter devices
echo.

set /p continuar="Presiona Enter para ejecutar en el celular..."

echo.
echo Ejecutando Flutter desde ruta corta...
echo.

cd S:\styleme_front
flutter run -d R58N408972H

pause
