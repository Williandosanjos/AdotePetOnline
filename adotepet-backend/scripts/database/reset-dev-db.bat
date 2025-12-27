@echo off
echo ========================================
echo  RESET DO BANCO DE DADOS DEV
echo ========================================
echo.

echo [1/4] Parando container MySQL...
docker-compose stop mysql-dev

echo [2/4] Removendo volume de dados...
docker-compose down -v mysql-dev

echo [3/4] Recriando container...
docker-compose up -d mysql-dev
timeout /t 10 /nobreak >nul

echo [4/4] Executando scripts de inicialização...
docker exec -i adotepet-mysql-dev mysql -uroot -proot adotepet_dev < scripts\database\init-dev.sql

echo.
echo Banco de dados DEV resetado com sucesso!
echo.
pause