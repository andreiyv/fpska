@echo off &setlocal
setlocal enabledelayedexpansion

set video_file=%~f1

"%~dp0\fpska.bat" lossless "!video_file!"

endlocal
