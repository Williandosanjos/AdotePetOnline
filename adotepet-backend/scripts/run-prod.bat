@echo off
echo ========================================
echo  SIMULAÇÃO AMBIENTE PRODUÇÃO
echo  (Para produção real, use Docker)
echo ========================================
echo.

set SPRING_PROFILES_ACTIVE=prod
set DB_URL=jdbc:mysql://localhost:3306/adotepet_prod
set DB_USERNAME=admin
echo Informe a senha do banco PROD:
set /p DB_PASSWORD=

if "%DB_PASSWORD%"=="" (
    echo ERRO: Senha não informada!
    pause
    exit /b 1
)

echo [1/3] Build otimizado para produção...
call mvn clean package -DskipTests -Pprod
if %errorlevel% neq 0 (
    echo ERRO no build!
    pause
    exit /b 1
)

echo [2/3] Criando diretórios de produção...
if not exist "C:\adotepet\logs" mkdir "C:\adotepet\logs"
if not exist "C:\adotepet\uploads" mkdir "C:\adotepet\uploads"

echo [3/3] Iniciando em modo produção...
echo.
echo AVISO: Esta é uma simulação. Em produção real:
echo 1. Use Docker containers
echo 2. Configure reverse proxy (Nginx)
echo 3. Use HTTPS com certificado SSL
echo 4. Configure monitoramento
echo.

java -jar ^
  -Dspring.profiles.active=prod ^
  -Dserver.port=8080 ^
  -Xms256m ^
  -Xmx512m ^
  -XX:+UseG1GC ^
  -XX:MaxGCPauseMillis=200 ^
  target\adotepet-backend-0.0.1-SNAPSHOT.jar