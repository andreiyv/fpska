@echo off &setlocal

echo -----------------------------------------------------------------
echo  Download FFmpeg
echo -----------------------------------------------------------------
if exist "%~dp0ffmpeg" (
rmdir /S/Q ffmpeg
)

"%~dp0distr\curl.exe" https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.1.1-win64-static.zip --output "%~dp0\ffmpeg-4.1.1-win64-static.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0\ffmpeg-4.1.1-win64-static.zip" -o"%~dp0"
rename "%~dp0\ffmpeg-4.1.1-win64-static" "ffmpeg"
del "%~dp0ffmpeg-4.1.1-win64-static.zip"
echo.


echo -----------------------------------------------------------------
echo Download Python and Vapoursynth
echo -----------------------------------------------------------------
if exist "%~dp0python" (
rmdir /S/Q python
)
"%~dp0distr\curl.exe" https://andreyv.ru/distrib/python-wx.zip --output "%~dp0\python.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0\python.zip" -o"%~dp0"
del %~dp0\python.zip
echo.



echo -----------------------------------------------------------------
echo Download SVPflow libraries
echo -----------------------------------------------------------------
"%~dp0distr\curl.exe" http://www.svp-team.com/files/gpl/svpflow-4.2.0.142.zip --output "%~dp0svpflow-4.2.0.142.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0\svpflow-4.2.0.142.zip" -o"%~dp0"
copy "%~dp0svpflow-4.2.0.142\lib-windows\vapoursynth\x64\*.dll" "%~dp0python\vapoursynth64\plugins"
del "%~dp0svpflow-4.2.0.142.zip"
rmdir /S/Q "%~dp0\svpflow-4.2.0.142"
echo.



echo -----------------------------------------------------------------
echo Download eac3to
echo -----------------------------------------------------------------
if exist "%~dp0eac3to" (
rmdir /S/Q eac3to
)
"%~dp0distr\curl.exe" https://andreyv.ru/distrib/eac3to334.zip --output "%~dp0eac3to334.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0\eac3to334.zip" -o"%~dp0\eac3to"
del "%~dp0\eac3to334.zip"
echo.



echo -----------------------------------------------------------------
echo Download mkvtoolnix
echo -----------------------------------------------------------------
if exist "%~dp0mkvtoolnix" (
rmdir /S/Q mkvtoolnix
)
"%~dp0distr\curl.exe" https://andreyv.ru/distrib/mkvtoolnix.zip --output "%~dp0mkvtoolnix.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0\mkvtoolnix.zip" -o"%~dp0\mkvtoolnix"
del "%~dp0\mkvtoolnix.zip"
echo.



PAUSE
