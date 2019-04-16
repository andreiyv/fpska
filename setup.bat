rem AviSynth
%~dp0distr\AviSynth_260.exe /S
copy %~dp0distr\avisynth.dll c:\Windows\SysWOW64
copy %~dp0distr\avisynth.dll c:\Windows\System32

rem FFMS2
rem %~dp0distr\curl.exe -L https://github.com/FFMS/ffms2/releases/download/2.22/ffms2-2.22-msvc.7z --output %~dp0\FFMS2\ffms2-2.22-msvc.7z
rem %~dp0distr\7za.exe x %~dp0\FFMS2\ffms2-2.22-msvc.7z -o%~dp0\FFMS2
rem copy %~dp0\FFMS2\ffms2-2.22-msvc\x64\*.* %~dp0\FFMS2
rem copy %~dp0\FFMS2\ffms2-2.22-msvc\*.avsi %~dp0\FFMS2
rem del %~dp0\FFMS2\ffms2-2.22-msvc.7z
rem rmdir /S/Q %~dp0\FFMS2\ffms2-2.22-msvc

rem Mencoder
rem %~dp0distr\curl.exe https://kent.dl.sourceforge.net/project/mplayerwin/MPlayer-MEncoder/r38119/mplayer-svn-38119.7z --output %~dp0\mencoder\mplayer-svn-38119.7z
rem %~dp0distr\7za.exe x %~dp0\mencoder\mplayer-svn-38119.7z -o%~dp0\mencoder
rem copy %~dp0\mencoder\mplayer-svn-38119\*.exe %~dp0\mencoder
rem copy %~dp0\mencoder\mplayer-svn-38119\*.dll %~dp0\mencoder
rem del %~dp0\mencoder\mplayer-svn-38119.7z
rem rmdir /S/Q %~dp0\mencoder\mplayer-svn-38119

rem FFmpeg
%~dp0distr\curl.exe https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip --output %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip
%~dp0distr\7za.exe x %~dp0\ffmpeg\ffmpeg-latest-win32-static.zip -o%~dp0\ffmpeg
copy %~dp0\ffmpeg\ffmpeg-latest-win32-static\bin\*.exe %~dp0ffmpeg
del %~dp0ffmpeg\ffmpeg-latest-win32-static.zip
rmdir /S/Q %~dp0ffmpeg\ffmpeg-latest-win32-static


rem SVPflow
%~dp0distr\curl.exe http://www.svp-team.com/files/gpl/svpflow-4.2.0.142.zip --output %~dp0\svpflow\svpflow-4.2.0.142.zip
%~dp0distr\7za.exe x %~dp0\svpflow\svpflow-4.2.0.142.zip -o%~dp0\svpflow
copy %~dp0svpflow\svpflow-4.2.0.142\lib-windows\avisynth\x32\*.dll %~dp0svpflow
del %~dp0svpflow\svpflow-4.2.0.142.zip
rmdir /S/Q %~dp0svpflow\svpflow-4.2.0.142

rem eac3to
%~dp0distr\curl.exe https://www.videohelp.com/download/eac3to334.zip --output %~dp0\eac3to\eac3to334.zip 
%~dp0distr\7za.exe x %~dp0\eac3to\eac3to334.zip
del %~dp0\eac3to\eac3to334.zip

rem mkvtoolnix
https://download.fosshub.com/Protected/expiretime=1555383126;badurl=aHR0cHM6Ly93d3cuZm9zc2h1Yi5jb20vTUtWVG9vbE5peC5odG1s/79437068bd8b1e845f190ab288728b94d619d76429fb262585d33049b1deacac/5b8f889d59eee027c3d78aab/5cb43029735d24df2a37e542/mkvtoolnix-32-bit-33.1.0.7z

PAUSE
