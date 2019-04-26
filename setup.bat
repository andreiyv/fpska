@echo off &setlocal

rem AviSynth
rem %~dp0distr\AviSynth_260.exe /S
rem copy %~dp0distr\avisynth.dll c:\Windows\SysWOW64
rem copy %~dp0distr\avisynth.dll c:\Windows\System32

rem FFmpeg
%~dp0distr\curl.exe https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip --output %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip
%~dp0distr\7za.exe -aoa x %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip -o%~dp0\ffmpeg
copy %~dp0\ffmpeg\ffmpeg-latest-win32-static\bin\*.exe %~dp0ffmpeg
del %~dp0ffmpeg\ffmpeg-latest-win32-static.zip
rmdir /S/Q %~dp0ffmpeg\ffmpeg-latest-win32-static

rem python
%~dp0distr\curl.exe https://andreyv.ru/distrib/python.zip --output %~dp0\python.zip
%~dp0distr\7za.exe -aoa x %~dp0\python.zip -o%~dp0\
del %~dp0\python.zip


rem SVPflow
%~dp0distr\curl.exe http://www.svp-team.com/files/gpl/svpflow-4.2.0.142.zip --output %~dp0\svpflow\svpflow-4.2.0.142.zip
%~dp0distr\7za.exe -aoa x %~dp0\svpflow\svpflow-4.2.0.142.zip -o%~dp0\svpflow
copy %~dp0svpflow\svpflow-4.2.0.142\lib-windows\avisynth\x32\*.dll %~dp0svpflow
del %~dp0svpflow\svpflow-4.2.0.142.zip
rmdir /S/Q %~dp0svpflow\svpflow-4.2.0.142

rem eac3to
%~dp0distr\curl.exe https://andreyv.ru/distrib/eac3to334.zip --output %~dp0\eac3to\eac3to334.zip 
%~dp0distr\7za.exe -aoa x %~dp0\eac3to\eac3to334.zip -o%~dp0\eac3to
del %~dp0\eac3to\eac3to334.zip

rem mkvtoolnix
%~dp0distr\curl.exe https://andreyv.ru/distrib/mkvtoolnix.zip --output %~dp0\mkvtoolnix.zip
%~dp0distr\7za.exe -aoa x %~dp0\mkvtoolnix.zip -o%~dp0\mkvtoolnix
del %~dp0\mkvtoolnix.zip

rem mountains.mp4
rem %~dp0distr\curl.exe https://andreyv.ru/distrib/mountains.mp4 --output %~dp0\mountains.mp4

PAUSE
