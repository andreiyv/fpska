@echo off &setlocal
setlocal enabledelayedexpansion

set video_file=%~f1

"%~dp0\scripts\fpska.bat" medium "!video_file!"

endlocal

