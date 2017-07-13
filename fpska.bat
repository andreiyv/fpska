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

@echo on

rem %cd%/x264/x264-win32.exe --preset veryslow --output "60fps.mkv" "%cd%\scripts\work.avs"
%cd%\mencoder\mencoder.exe %cd%\scripts\work.avs -oac copy -ovc x264 -x264encopts preset=veryslow -o 60fps.mp4
rem ffmpeg\ffmpeg.exe  -i "%cd%\scripts\work.avs"  -c:v libx264  -x264-params preset=slow  -y video.mkv

rem del %cd%\scripts\work.avs
rem del *.ffindex

%cd%\mencoder\mencoder.exe -audiofile audio.wav 60fps.mp4 -o 60fps_video_and_audio.mp4 -ovc copy -oac copy



echo %time%


