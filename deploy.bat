@echo off
cd /d "%~dp0"
echo Removendo locks do git...
del /f /q .git\index.lock 2>nul
del /f /q .git\HEAD.lock 2>nul
echo Fazendo commit e push...
git add index.html admin/index.html
git commit -m "feat: admin config tab, responsive total, PIX dinamico do banco"
git push origin main
echo.
echo Pronto! Vercel vai fazer o deploy automaticamente.
pause
