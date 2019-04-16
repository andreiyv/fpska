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

echo File:  %~f1
echo Extension:  %~x1

set video_file=%~f1
set video_ext=%~x1

set container=""
set audio_codeck=""

rem ============= get info =========================

%cd%\ffmpeg\ffprobe.exe -i !video_file! > %cd%\log.txt 2> %cd%\ffprobe.log

findstr /m "aac" ffprobe.log
if %errorlevel%==0 (
	set audio_codeck=aac
)

findstr /m "matroska" ffprobe.log
if %errorlevel%==0 (
	set container=mkv
)

findstr /m "mov,mp4,m4a,3gp,3g2,mj2" ffprobe.log
if %errorlevel%==0 (
	set container=mp4
)

echo container: !container!
echo audio: !audio_codeck!

rem =================================================
rem
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

echo Method: !method!

rem =================================================

mkdir %cd%\tmp

@echo off

echo %time%

rem ============== extract audio ====================
if "!container!"=="mp4" (
echo Extrating audio for mp4	
%cd%\ffmpeg\ffmpeg.exe -y -i %1 -vn -acodec copy %cd%\tmp\60fps_audio.aac -v quiet -stats 
)
rem =================================================

rem ============== prepare script ===================
if "!method!"=="slow" (
copy %cd%\scripts\fpska_slow.avs %cd%\scripts\work.avs
) else if "!method!"=="fast" (
copy %cd%\scripts\fpska_fast.avs %cd%\scripts\work.avs
)
set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=!video_file!"
set "threads=!ncpu!"

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
rem =================================================
rem
rem =========== convert to 60fps video ==============
if "!method!"=="slow" (
%cd%\ffmpeg\ffmpeg.exe -y -i %cd%\scripts\work.avs -c:a copy -c:v libx264 -crf 20 -preset slow %cd%\tmp\60fps_video.mp4 -v quiet -stats
) else if "!method!"=="fast" (
%cd%\ffmpeg\ffmpeg.exe -y -i %cd%\scripts\work.avs -c:a copy -c:v libx264 -crf 20 -preset slow %cd%\tmp\60fps_video.mp4 -v quiet -stats
)
rem =================================================

rem del %cd%\scripts\work.avs
rem del *.ffindex

rem =========== merge audio and 60fps video =========
%cd%\ffmpeg\ffmpeg.exe -y -i %cd%\tmp\60fps_video.mp4 -i %cd%\tmp\60fps_audio.aac -c:v copy -c:a copy 60fps.mp4 -v quiet -stats
rem =================================================

endlocal
echo %time%
pause


:Info_Message
echo ------------------------------------------
echo. 
echo %~1
echo. 
echo ------------------------------------------
EXIT /B 0
