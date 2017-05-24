@echo off &setlocal
setlocal enabledelayedexpansion

echo %time%

copy %cd%\scripts\fpska.avs %cd%\scripts\work.avs

set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=%1"
set "threads=%2"
set "textfile=%cd%\scripts\work.avs"
set "newfile=%cd%\scripts\tmp.txt"

(for /f "delims=" %%i in (%textfile%) do (
    set "line=%%i"
    set "line=!line:%search%=%replace%!"
    set "line=!line:%search_threads%=%threads%!"
    echo(!line!
))>"%newfile%"
del %cd%\scripts\work.avs
ren %cd%\scripts\tmp.txt work.avs
endlocal

@echo on

%cd%/x264/x264-win32.exe --preset veryslow --output "60fps.mkv" "%cd%\scripts\work.avs"



rem del %cd%\scripts\work.avs
rem del *.ffindex


echo %time%


