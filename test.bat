@echo off
%cd%\ffmpeg\ffprobe.exe -i video.mp4 > %cd%\log.txt 2> %cd%\ffprobe.log 

findstr /m "wma" ffprobe.log

if %errorlevel%==0 (
echo aac
)
