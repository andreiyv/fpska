@echo off
%~dp0python\python.exe %~dp0scripts\fpska_gui.py
if %errorlevel%==0 (
    exit
) else (
    pause
)
