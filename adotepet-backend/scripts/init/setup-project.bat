@echo off
echo ========================================
echo  CONFIGURAÇÃO DO PROJETO ADOTE PET ONLINE
echo ========================================
echo.

REM 1.verificar pré-requisitos
echo [1/5] Verificando pré-requisitos...
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: Java não encontrado!
    echo Instale Java 17: https://adoptium.net/
    pause
    exit /b 1
)

where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: Maven não encontrado!
    echo Instale Maven: https://maven.apache.org/
    pause
    exit /b 1
)

where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo AVISO: Docker não encontrado. Alguns scripts não funcionarão.
)

REM 2.0 Criar diretórios necessários
echo [2/5] Criando estrutura de diretórios...
if not exist "uploads" mkdir uploads
if not exist "logs" mkdir logs
if not exist "src/main/resources/static/images" mkdir "src/main/resources/static/images"

REM 3. Configurar ambiente
echo [3/5] Configurando variáveis de ambiente...
set SPRING_PROFILES_ACTIVE=dev
echo Ambiente configurado: %SPRING_PROFILES_ACTIVE%

REM 4. Instalar dependências
echo [4/5] Instalando dependências Maven...
call mvn clean install -DskipTests

REM 5. Iniciando banco de dados
echo [5/5] iniciando MySQL via Docker...

echo.
echo ========================================
echo  CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!
echo ========================================
echo.
echo Comandos disponíveis:
echo   scripts\run-dev.bat     - Iniciar ambiente DEV
echo   scripts\run-hml.bat     - Iniciar ambiente HML
echo   scripts\stop-all.bat    - Parar todos os serviços
echo.
pause