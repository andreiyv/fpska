@echo off &setlocal
setlocal enabledelayedexpansion

if [%1]==[] (
echo Vvedite imya video
exit
)

echo "full video path: " %~f1
echo "video extension: " %~x1

set video_file=%~f1
echo "video_file: " !video_file!

if "%~x1"==".MTS" (
echo "this is mts video need to convert"
%cd%\mencoder\mencoder !video_file! -demuxer lavf -oac copy -ovc copy -of lavf=mp4 -o %cd%\mtsvideo.mp4
set video_file=mtsvideo.mp4
)

if "%~x1"==".mts" (
echo "this is mts video need to convert"
%cd%\mencoder\mencoder !video_file! -demuxer lavf -oac copy -ovc copy -of lavf=mp4 -o %cd%\mtsvideo.mp4
set video_file=mtsvideo.mp4
)

set method=fast
set ncpu=2

if [%2]==[] (
set method=slow
) else (
set method=%2
)

if [%3]==[] (
set ncpu=4
) else (
set ncpu=%3
)

echo "ncpu: " !ncpu!
echo "1 method: " !method!
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
%cd%\mencoder\mplayer.exe -vc dummy -vo null -ao pcm:file=60fps_audio.wav,fast %1 -msglevel all=0

rem prepare script
if "!method!"=="slow" (
rem echo "slow"
copy %cd%\scripts\fpska_slow.avs %cd%\scripts\work.avs
) else if "!method!"=="fast" (
rem echo "fast"
copy %cd%\scripts\fpska_fast.avs %cd%\scripts\work.avs
)
echo "2 method: " !method!
set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=!video_file!"
set "threads=!ncpu!"
echo "threads: " !threads!

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


echo "3 method: " !method!

rem convert to 60fps video
if "!method!"=="slow" (
echo "slow"
%cd%\mencoder\mencoder.exe %cd%\scripts\work.avs -oac copy -ovc x264 -x264encopts preset=veryslow:bitrate=18000:threads=auto -o %cd%\60fps_video.mp4
) else if "!method!"=="fast" (
echo "fast"
%cd%\mencoder\mencoder.exe %cd%\scripts\work.avs -oac copy -ovc x264 -x264encopts preset=veryfast -o %cd%\60fps_video.mp4
)



rem del %cd%\scripts\work.avs
rem del *.ffindex

rem merge audio and 60fps video
%cd%\mencoder\mencoder.exe -audiofile 60fps_audio.wav 60fps_video.mp4 -o 60fps_video_and_audio.mp4 -ovc copy -oac copy

rem del %cd%\60fps_video.mp4
rem del 60fps_audio.wav
rem ren 60fps_video_and_audio.mp4 60fps.mp4

rem mplayer -vo null -ao null -identify -frames 0 /path/to/file
rem mencoder\mencoder video.MTS -demuxer lavf -oac copy -ovc copy -of lavf=mp4 -o mtsvideo.mp4
endlocal
echo %time%
pause

