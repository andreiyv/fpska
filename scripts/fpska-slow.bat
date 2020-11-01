@echo off &setlocal
setlocal enabledelayedexpansion

set video_file=%~f1

"%~dp0\scripts\fpska.bat" slow "!video_file!"

endlocal
