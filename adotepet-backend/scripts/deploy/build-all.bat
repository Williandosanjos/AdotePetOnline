@echo off
echo ========================================
echo  BUILD COMPLETO PARA DOCKER
echo ========================================
echo.

echo [1/4] Buildando backend...
docker build -t adotepet/backend:latest -f Dockerfile .

echo [2/4] Buildando frontend (se existir)...
if exist "../frontend" (
    cd ../frontend
    docker build -t adotepet/frontend:latest -f Dockerfile .
    cd ../backend
)

echo [3/4] Subindo containers...
docker-compose up -d --build

echo [4/4] Verificando serviços...
timeout /t 5 /nobreak >nul
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo Todos os serviços estão rodando!
echo.
pause