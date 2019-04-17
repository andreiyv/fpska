rem AviSynth
%~dp0distr\AviSynth_260.exe /S
copy %~dp0distr\avisynth.dll c:\Windows\SysWOW64
copy %~dp0distr\avisynth.dll c:\Windows\System32

rem FFmpeg
%~dp0distr\curl.exe https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip --output %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip
%~dp0distr\7za.exe -aoa x %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip -o%~dp0\ffmpeg
copy %~dp0\ffmpeg\ffmpeg-latest-win32-static\bin\*.exe %~dp0ffmpeg
del %~dp0ffmpeg\ffmpeg-latest-win32-static.zip
rmdir /S/Q %~dp0ffmpeg\ffmpeg-latest-win32-static


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
%~dp0distr\curl.exe https://andreyv.ru/distrib/mkvtoolnix-32-bit-33.1.0.7z --output %~dp0\mkvtoolnix-32-bit-33.1.0.7z
rem timeout 3 > NUL
%~dp0distr\7za.exe -aoa -y x %~dp0\mkvtoolnix-32-bit-33.1.0.7z
timeout 3 > NUL
del %~dp0\mkvtoolnix-32-bit-33.1.0.7z

rem mountains.mp4
%~dp0distr\curl.exe https://andreyv.ru/distrib/mountains.mp4 --output %~dp0\mountains.mp4

PAUSE
