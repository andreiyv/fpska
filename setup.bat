@echo off &setlocal

echo -----------------------------------------------------------------
echo  Download FFmpeg
echo -----------------------------------------------------------------
if exist "%~dp0ffmpeg" (
rmdir /S/Q ffmpeg
)



"%~dp0distr\curl.exe" https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.2-win64-static.zip --output "%~dp0ffmpeg-4.2-win64-static.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0ffmpeg-4.2-win64-static.zip" -o"%~dp0"
rename "%~dp0ffmpeg-4.2-win64-static" "ffmpeg"
del "%~dp0ffmpeg-4.2-win64-static.zip"
echo.


echo -----------------------------------------------------------------
echo Download Python and Vapoursynth
echo -----------------------------------------------------------------
if exist "%~dp0python" (
rmdir /S/Q python
)
"%~dp0distr\curl.exe" https://andreyv.ru/distrib/python-wx.zip --output "%~dp0python.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0python.zip" -o"%~dp0"
del "%~dp0python.zip"
echo.



echo -----------------------------------------------------------------
echo Download SVPflow libraries
echo -----------------------------------------------------------------
"%~dp0distr\curl.exe" https://www.svp-team.com/files/gpl/svpflow-4.2.0.142.zip --output "%~dp0svpflow-4.2.0.142.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0svpflow-4.2.0.142.zip" -o"%~dp0"
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
"%~dp0distr\7za.exe" -aoa x "%~dp0eac3to334.zip" -o"%~dp0eac3to"
del "%~dp0eac3to334.zip"
echo.



echo -----------------------------------------------------------------
echo Download mkvtoolnix
echo -----------------------------------------------------------------
if exist "%~dp0mkvtoolnix" (
rmdir /S/Q mkvtoolnix
)
"%~dp0distr\curl.exe" https://andreyv.ru/distrib/mkvtoolnix.zip --output "%~dp0mkvtoolnix.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0mkvtoolnix.zip" -o"%~dp0mkvtoolnix"
del "%~dp0mkvtoolnix.zip"
echo.



echo -----------------------------------------------------------------
echo Download Mediainfo CLI
echo -----------------------------------------------------------------
if exist "%~dp0mkvtoolnix" (
rmdir /S/Q Mediainfo
)
"%~dp0distr\curl.exe" https://mediaarea.net/download/binary/mediainfo/19.04/MediaInfo_CLI_19.04_Windows_x64.zip --output "%~dp0MediaInfo_CLI_19.04_Windows_x64.zip"
"%~dp0distr\7za.exe" -aoa x "%~dp0MediaInfo_CLI_19.04_Windows_x64.zip" -o"%~dp0Mediainfo_CLI"
del "%~dp0MediaInfo_CLI_19.04_Windows_x64.zip"
echo.


PAUSE
