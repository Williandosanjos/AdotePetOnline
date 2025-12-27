@echo off
echo ========================================
echo  INICIANDO ADOTE PET ONLINE - DESENVOLVIMENTO
echo ========================================
echo Data: %date% %time%
echo.

REM Configurar ambiente DEV
set SPRING_PROFILES_ACTIVE=dev
set DB_URL=jdbc:mysql://localhost:3306/adotepet_dev
set DB_USERNAME=root
set DB_PASSWORD=root
set JWT_SECRET=dev-secret-key-change-in-production

echo [1/4] Parando containers existentes...
docker-compose down

echo [2/4] Iniciando MySQL...
docker-compose up -d mysql-dev
timeout /t 10 /nobreak >nul
echo MySQL iniciado na porta 3306

echo [3/4] Buildando aplicação...
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ERRO no build do Maven!
    pause
    exit /b 1
)

echo [4/4] Iniciando aplicação Spring Boot...
echo.
echo ========================================
echo  APLICAÇÃO INICIADA - AMBIENTE DEV
echo ========================================
echo URL API: http://localhost:8080/api
echo Swagger: http://localhost:8080/api/swagger-ui.html
echo Health:  http://localhost:8080/api/actuator/health
echo.
echo Pressione CTRL+C para parar
echo.

java -jar -Dspring.profiles.active=dev target\adotepet-backend-0.0.1-SNAPSHOT.jar