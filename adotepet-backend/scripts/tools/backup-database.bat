@echo off
echo ========================================
echo  BACKUP DO BANCO DE DADOS
echo ========================================
echo.

set BACKUP_DIR=backups
set TIMESTAMP=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%
set BACKUP_FILE=%BACKUP_DIR%\adotepet_backup_%TIMESTAMP%.sql

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo [1/3] Fazendo backup do banco DEV...
docker exec adotepet-mysql-dev mysqldump -uroot -proot adotepet_dev > "%BACKUP_FILE%"

echo [2/3] Comprimindo backup...
where 7z >nul 2>nul
if %errorlevel% equ 0 (
    7z a "%BACKUP_FILE%.7z" "%BACKUP_FILE%"
    del "%BACKUP_FILE%"
    echo Backup comprimido: %BACKUP_FILE%.7z
) else (
    echo Backup salvo: %BACKUP_FILE%
)

echo [3/3] Limpando backups antigos (mais de 30 dias)...
forfiles /P "%BACKUP_DIR%" /S /M *.sql /D -30 /C "cmd /c del @path"
forfiles /P "%BACKUP_DIR%" /S /M *.7z /D -30 /C "cmd /c del @path"

echo.
echo Backup concluído com sucesso!
echo.
pause