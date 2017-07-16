@echo off &setlocal
setlocal enabledelayedexpansion

if exist %cd%\svpflow\svpflow1.dll (
    rem file exists
) else (
    echo "---------------------------"
    echo Net biblioteki svpflow1.dll
    echo svpflow\readme.txt - instruktsiya po ustanovke
    echo "---------------------------"
    exit /B
)

if exist %cd%\svpflow\svpflow2.dll (
    rem file exists
) else (
    echo "---------------------------"
    echo Net biblioteki svpflow2.dll
    echo svpflow\readme.txt - instruktsiya po ustanovke
    echo "---------------------------"
    exit /B
)
@echo off

echo %time%

rem extract audio
%cd%\mencoder\mplayer.exe -vc dummy -vo null -ao pcm:file=audio.wav,fast %1

rem prepare script
if "%2"=="slow" (
echo "slow"
copy %cd%\scripts\fpska_slow.avs %cd%\scripts\work.avs
) else if "%2"=="fast" (
echo "fast"
copy %cd%\scripts\fpska_fast.avs %cd%\scripts\work.avs
)

set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=%1"
set "threads=%3"
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

rem convert to 60fps video
mencoder\mencoder.exe scripts\work.avs -oac copy -ovc x264 -x264encopts preset=veryslow -o 60fps.mp4

rem del %cd%\scripts\work.avs
del *.ffindex

rem merge audio and 60fps video
mencoder\mencoder.exe -audiofile audio.wav 60fps.mp4 -o 60fps_video_and_audio.mp4 -ovc copy -oac copy

del %cd%\60fps.mp4
del audio.wav
ren 60fps_video_and_audio.mp4 60fps.mp4

rem mplayer -vo null -ao null -identify -frames 0 /path/to/file

echo %time%


