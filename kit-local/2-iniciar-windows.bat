@echo off
rem Doble clic para abrir God's Eye View - La Guajira (ya preparado).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0preparar-windows.ps1" -SoloIniciar %*
pause
