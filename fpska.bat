@echo off &setlocal
setlocal enabledelayedexpansion

cls

CALL :Info_Message "fpska v0.5"

if [%1]==[] (
echo Vvedite imya video
exit
)

rem ============= init =============================
set ffmpeg_threads=1
set method=slow
set ncpu=2
rem =================================================

echo "full video path: " %~f1
echo "video extension: " %~x1

set video_file=%~f1
echo "video_file: " !video_file!

rem ========== Convert MTS to MP4 ===================
if "%~x1"==".MTS" (
echo "this is mts video need to convert"
%cd%\ffmpeg\ffmpeg.exe -i !video_file! -c:v copy -c:a aac -b:a 320k mtsvideo.mp4 -hide_banner
set video_file=mtsvideo.mp4
)

if "%~x1"==".mts" (
echo "this is mts video need to convert"
%cd%\ffmpeg\ffmpeg.exe -i !video_file! -c:v copy -c:a aac -b:a 320k mtsvideo.mp4 -hide_banner
set video_file=mtsvideo.mp4
)
rem =================================================

rem ===================== set nethod ================
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

rem =================================================

@echo off

echo %time%

rem ============== extract audio ====================
%cd%\ffmpeg\ffmpeg.exe -y -i %1 -vn -acodec copy 60fps_audio.aac -v quiet -stats 
rem =================================================

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

rem =========== convert to 60fps video =============
if "!method!"=="slow" (
echo "slow"
%cd%\ffmpeg\ffmpeg.exe -y -i %cd%\scripts\work.avs -c:a copy -c:v libx264 -crf 20 -preset slow %cd%\60fps_video.mp4 -v quiet -stats
) else if "!method!"=="fast" (
echo "fast"
%cd%\ffmpeg\ffmpeg.exe -y -i %cd%\scripts\work.avs -c:a copy -c:v libx264 -crf 20 -preset slow %cd%\60fps_video.mp4 -v quiet -stats
)
rem =================================================

rem del %cd%\scripts\work.avs
rem del *.ffindex

rem =========== merge audio and 60fps video =========
%cd%\ffmpeg\ffmpeg.exe -y -i 60fps_video.mp4 -i 60fps_audio.aac -c:v copy -c:a copy 60fps.mp4 -v quiet -stats
rem =================================================

endlocal
echo %time%
pause


:Info_Message
echo ------------------------------------------
echo  
echo %~1
echo  
echo ------------------------------------------
EXIT /B 0
