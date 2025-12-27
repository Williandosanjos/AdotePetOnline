@echo off
echo ========================================
echo  INICIANDO ADOTE PET ONLINE - HOMOLOGAÇÃO
echo ========================================
echo Data: %date% %time%
echo.

REM Configurar ambiente HML
set SPRING_PROFILES_ACTIVE=hml
set DB_URL=jdbc:mysql://localhost:3307/adotepet_hml
set DB_USERNAME=homolog
set DB_PASSWORD=homolog123
set JWT_SECRET=hml-secret-key-change-in-production

echo [1/4] Iniciando MySQL Homologação...
docker-compose up -d mysql-hml
timeout /t 15 /nobreak >nul
echo MySQL HML iniciado na porta 3307

echo [2/4] Build para produção...
call mvn clean package -DskipTests -Pprod
if %errorlevel% neq 0 (
    echo ERRO no build do Maven!
    pause
    exit /b 1
)

echo [3/4] Executando migrações de banco...
REM Aqui você pode adicionar Flyway/Liquibase
echo Migrações concluídas.

echo [4/4] Iniciando aplicação...
echo.
echo ========================================
echo  APLICAÇÃO INICIADA - AMBIENTE HML
echo ========================================
echo URL API: http://localhost:8080/api
echo Health:  http://localhost:8080/api/actuator/health
echo Logs:    logs\adotepet-hml.log
echo.
echo Pressione CTRL+C para parar
echo.

java -jar -Dspring.profiles.active=hml -Xmx512m target\adotepet-backend-0.0.1-SNAPSHOT.jar