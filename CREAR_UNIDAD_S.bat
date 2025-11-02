@echo off
title Crear Unidad Virtual S:
color 0B

cls
echo ========================================
echo    CREAR UNIDAD VIRTUAL S:
echo ========================================
echo.

echo Creando unidad S: ...
subst S: "D:\wendy\Universidad\9. Semestre 2025-2\Investigación III\Proyecto de grado - desarrollo"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo  UNIDAD S: CREADA EXITOSAMENTE
    echo ========================================
    echo.
    echo Ahora puedes usar:
    echo   - S:\styleme_front  (Frontend Flutter)
    echo   - S:\styleme_back   (Backend Django)
    echo.
    echo Esta unidad se mantendra hasta que reinicies Windows.
    echo.
) else (
    echo.
    echo ========================================
    echo  ERROR AL CREAR UNIDAD S:
    echo ========================================
    echo.
    echo La unidad S: ya existe o hubo un error.
    echo.
)

pause
