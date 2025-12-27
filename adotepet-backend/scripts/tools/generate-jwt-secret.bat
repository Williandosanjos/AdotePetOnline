@echo off
echo ========================================
echo  GERADOR DE CHAVE SECRETA JWT
echo ========================================
echo.

echo Gerando chave segura para JWT...
echo.

REM Usando OpenSSL para gerar chave
where openssl >nul 2>nul
if %errorlevel% equ 0 (
    openssl rand -base64 32
) else (
    echo OpenSSL não encontrado. Gerando com PowerShell...
    powershell -Command "[System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))"
)

echo.
echo INSTRUÇÕES:
echo 1. Copie a chave acima
echo 2. Coloque no application-dev.yml: app.security.jwt.secret
echo 3. Para produção, use variáveis de ambiente
echo.
pause