# Script de verificación del backend StyleMe
# Fecha: 08 de Octubre, 2025

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "    VERIFICACIÓN DEL BACKEND - STYLEME" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar comando
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

# Función para verificar puerto
function Test-Port {
    param($Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
    return $connection.TcpTestSucceeded
}

# 1. Verificar Python
Write-Host "1. Verificando Python..." -ForegroundColor Yellow
if (Test-Command python) {
    $pythonVersion = python --version
    Write-Host "   ✅ Python instalado: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ Python no encontrado" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. Verificar entorno virtual
Write-Host "2. Verificando entorno virtual..." -ForegroundColor Yellow
if (Test-Path "env\Scripts\activate.ps1") {
    Write-Host "   ✅ Entorno virtual encontrado" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Entorno virtual no encontrado" -ForegroundColor Yellow
    Write-Host "   💡 Crear con: python -m venv env" -ForegroundColor Cyan
}
Write-Host ""

# 3. Verificar MongoDB
Write-Host "3. Verificando MongoDB..." -ForegroundColor Yellow
$mongoService = Get-Service -Name MongoDB -ErrorAction SilentlyContinue
if ($mongoService) {
    if ($mongoService.Status -eq "Running") {
        Write-Host "   ✅ MongoDB está corriendo" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  MongoDB instalado pero detenido" -ForegroundColor Yellow
        Write-Host "   💡 Iniciar con: net start MongoDB" -ForegroundColor Cyan
    }
} else {
    Write-Host "   ❌ MongoDB no encontrado" -ForegroundColor Red
}
Write-Host ""

# 4. Verificar puerto 27017 (MongoDB)
Write-Host "4. Verificando puerto MongoDB (27017)..." -ForegroundColor Yellow
if (Test-Port 27017) {
    Write-Host "   ✅ Puerto 27017 abierto" -ForegroundColor Green
} else {
    Write-Host "   ❌ Puerto 27017 cerrado" -ForegroundColor Red
    Write-Host "   💡 MongoDB no está escuchando" -ForegroundColor Cyan
}
Write-Host ""

# 5. Verificar archivos del proyecto
Write-Host "5. Verificando estructura del proyecto..." -ForegroundColor Yellow
$requiredFiles = @(
    "manage.py",
    "requirements.txt",
    "backend\settings.py",
    "recommendations\urls.py"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file no encontrado" -ForegroundColor Red
        $allFilesExist = $false
    }
}
Write-Host ""

# 6. Verificar logs directory
Write-Host "6. Verificando directorio de logs..." -ForegroundColor Yellow
if (Test-Path "logs") {
    Write-Host "   ✅ Directorio logs existe" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Directorio logs no existe" -ForegroundColor Yellow
    Write-Host "   💡 Se creará automáticamente al iniciar el servidor" -ForegroundColor Cyan
}
Write-Host ""

# 7. Verificar base de datos SQLite
Write-Host "7. Verificando base de datos SQLite..." -ForegroundColor Yellow
if (Test-Path "db.sqlite3") {
    $dbSize = (Get-Item "db.sqlite3").Length / 1KB
    Write-Host "   ✅ db.sqlite3 existe ($([math]::Round($dbSize, 2)) KB)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  db.sqlite3 no existe" -ForegroundColor Yellow
    Write-Host "   💡 Ejecutar: python manage.py migrate" -ForegroundColor Cyan
}
Write-Host ""

# 8. Verificar si el servidor está corriendo
Write-Host "8. Verificando servidor Django (puerto 8000)..." -ForegroundColor Yellow
if (Test-Port 8000) {
    Write-Host "   ✅ Servidor corriendo en puerto 8000" -ForegroundColor Green
    
    # Probar endpoint
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/" -UseBasicParsing -TimeoutSec 2
        Write-Host "   ✅ Servidor responde correctamente" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️  Puerto abierto pero servidor no responde" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  Servidor no está corriendo" -ForegroundColor Yellow
    Write-Host "   💡 Iniciar con: python manage.py runserver" -ForegroundColor Cyan
}
Write-Host ""

# 9. Verificar modelo YOLO
Write-Host "9. Verificando modelo YOLO..." -ForegroundColor Yellow
if (Test-Path "recommendations\ia\models\yolov8n.pt") {
    $modelSize = (Get-Item "recommendations\ia\models\yolov8n.pt").Length / 1MB
    Write-Host "   ✅ Modelo YOLO encontrado ($([math]::Round($modelSize, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Modelo YOLO no encontrado" -ForegroundColor Yellow
    Write-Host "   💡 Se descargará automáticamente en la primera detección" -ForegroundColor Cyan
}
Write-Host ""

# 10. Verificar archivos de documentación
Write-Host "10. Verificando documentación..." -ForegroundColor Yellow
$docFiles = @(
    "ARQUITECTURA_MODULAR.md",
    "API_CARGA_IMAGENES.md",
    "RESUMEN_PROYECTO.md"
)

foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        Write-Host "   ✅ $doc" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $doc no encontrado" -ForegroundColor Yellow
    }
}
Write-Host ""

# Resumen
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "    RESUMEN" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$readyToTest = $true

if (!(Test-Command python)) {
    Write-Host "❌ Python no instalado" -ForegroundColor Red
    $readyToTest = $false
}

if (!$mongoService -or $mongoService.Status -ne "Running") {
    Write-Host "❌ MongoDB no está corriendo" -ForegroundColor Red
    $readyToTest = $false
}

if (!(Test-Port 8000)) {
    Write-Host "⚠️  Servidor Django no está corriendo" -ForegroundColor Yellow
    $readyToTest = $false
}

if ($readyToTest) {
    Write-Host ""
    Write-Host "✅ Sistema listo para pruebas!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Próximos pasos:" -ForegroundColor Cyan
    Write-Host "1. Asegúrate de que el servidor esté corriendo:" -ForegroundColor White
    Write-Host "   python manage.py runserver" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Ejecuta el script de prueba:" -ForegroundColor White
    Write-Host "   python test_carga_imagenes.py" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. O prueba con curl:" -ForegroundColor White
    Write-Host "   curl -X POST http://localhost:8000/api/detect-clothing/ ``" -ForegroundColor Gray
    Write-Host "     -F `"email=test@example.com`" ``" -ForegroundColor Gray
    Write-Host "     -F `"image=@tu_imagen.jpg`"" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "⚠️  Sistema no está completamente listo" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Acciones requeridas:" -ForegroundColor Cyan
    
    if (!$mongoService -or $mongoService.Status -ne "Running") {
        Write-Host "• Iniciar MongoDB: net start MongoDB" -ForegroundColor White
    }
    
    if (!(Test-Port 8000)) {
        Write-Host "• Iniciar servidor: python manage.py runserver" -ForegroundColor White
    }
    
    Write-Host ""
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Para más información, consulta:" -ForegroundColor Cyan
Write-Host "   - GUIA_VERIFICACION_BACKEND.md" -ForegroundColor White
Write-Host "   - API_CARGA_IMAGENES.md" -ForegroundColor White
Write-Host "   - COMANDOS_UTILES.md" -ForegroundColor White
Write-Host ""
