@echo off
title StyleMe - Reiniciar Backend y App
color 0C

cls
echo ========================================
echo    STYLEME - REINICIAR SERVICIOS
echo ========================================
echo.

echo [1/3] Deteniendo procesos anteriores...
echo.
taskkill /F /IM python.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/3] Iniciando Backend en 0.0.0.0:8000...
echo.
echo IMPORTANTE: El backend debe usar 0.0.0.0:8000 (no 127.0.0.1:8000)
echo.
cd S:\styleme_back
start "StyleMe Backend" cmd /k "python manage.py runserver 0.0.0.0:8000"
timeout /t 3 /nobreak >nul

echo [3/3] Iniciando Flutter...
echo.
cd S:\styleme_front
start "StyleMe Flutter" cmd /k "flutter run -d R58N408972H"

echo.
echo ========================================
echo  SERVICIOS INICIADOS
echo ========================================
echo.
echo Backend: http://192.168.0.7:8000
echo Flutter: Ejecutando en celular
echo.
echo Presiona cualquier tecla para cerrar esta ventana...
pause >nul
