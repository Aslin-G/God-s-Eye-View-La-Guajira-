@echo off
rem Doble clic para descargar, instalar y abrir God's Eye View - La Guajira.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0preparar-windows.ps1" %*
pause
