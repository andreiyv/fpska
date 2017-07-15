@echo off &setlocal
setlocal enabledelayedexpansion

echo %time%

rem extract audio
%cd%\mencoder\mplayer.exe -vc dummy -vo null -ao pcm:file=audio.wav,fast %1

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

rem convert to 60fps video
mencoder\mencoder.exe scripts\work.avs -oac copy -ovc x264 -x264encopts preset=veryslow -o 60fps.mp4

del %cd%\scripts\work.avs
del *.ffindex

rem merge audio and 60fps video
%cd%\mencoder\mencoder.exe -audiofile audio.wav 60fps.mp4 -o 60fps_video_and_audio.mp4 -ovc copy -oac copy

del %cd%\60fps.mp4
del audio.wav
ren 60fps_video_and_audio.mp4 60fps.mp4

rem mplayer -vo null -ao null -identify -frames 0 /path/to/file

echo %time%


