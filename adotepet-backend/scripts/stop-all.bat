@echo off
echo ========================================
echo  PARANDO TODOS OS SERVIÇOS
echo ========================================
echo.

echo [1/3] Parando aplicação Spring Boot...
taskkill /F /IM java.exe 2>nul

echo [2/3] Parando containers Docker...
docker-compose down

echo [3/3] Limpando arquivos temporários...
if exist "target" (
    rmdir /S /Q target 2>nul
)
if exist "logs\*.log" (
    del /Q logs\*.log 2>nul
)

echo.
echo Todos os serviços foram parados!
echo.
pause