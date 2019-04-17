@echo off &setlocal
setlocal enabledelayedexpansion

echo %1

%~dp0\fpska.bat fast "%1"

endlocal

