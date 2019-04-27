@echo off &setlocal
setlocal enabledelayedexpansion

set video_file=%~f1

%~dp0\fpska.bat fast "!video_file!"

endlocal

