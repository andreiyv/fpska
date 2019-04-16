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

FOR %%i IN ("%~f1") DO (
ECHO filedrive=%%~di
ECHO filepath=%%~pi
set video_file_name=%%~ni
ECHO fileextension=%%~xi
)

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

rem ===================== set nethod ================
if [%2]==[] (
set method=fast
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

rmdir /S/Q %cd%\tmp
mkdir %cd%\tmp

@echo off

echo %time%

rem ============== extract audio ====================
if "!container!"=="mp4" (
echo Extrating audio for mp4	
%cd%\ffmpeg\ffmpeg.exe -y -i %1 -vn -acodec copy %cd%\tmp\60fps_audio.aac -v quiet -stats 
)


if "!container!"=="mkv" (

copy !video_file! %cd%\tmp
cd %cd%\tmp



%cd%\eac3to\eac3to.exe %cd%\tmp\!video_file_name!!video_ext! -demux

del %cd%\tmp\!video_file_name!!video_ext! 
del %cd%\tmp\*.txt
del %cd%\tmp\*.h264

cd %cd%

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
rem %cd%\ffmpeg\ffmpeg.exe -y -i %cd%\tmp\60fps_video.mp4 -i %cd%\tmp\60fps_audio.aac -c:v copy -c:a copy 60fps.mp4 -v quiet -stats

for %%i in (tmp\*.*) do set str=!str! "%%i"
echo !str!

%cd%\mkvtoolnix\mkvmerge.exe !str! -o 60fps.mkv

rem =================================================

del %cd%\log.txt
del %cd%\ffprobe.log
del %cd%\*.ffindex

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
