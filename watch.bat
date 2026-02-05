@echo off
cd /d "C:\Users\linyi\.openclaw\workspace\learning-tutorials"
:loop
powershell -ExecutionPolicy Bypass -File "%~dp0watch.ps1" >nul 2>&1
timeout /t 5 >nul
goto loop
