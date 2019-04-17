@echo off &setlocal
setlocal enabledelayedexpansion

echo %1

%~dp0\fpska.bat slow "%1"

endlocal

