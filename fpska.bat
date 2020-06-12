chcp 1251
@echo off &setlocal
setlocal enabledelayedexpansion

cls

CALL :Info_Message "fpska v0.9.1 - ������ ��� ������������ 60 fps"

set fpska_home=%~dp0
set ffmpeg_threads=1
set method=slow
set ncpu=2
set container=""
set audio_codeck=""
set audio_pcm=0
set video_file=%~2

FOR %%i IN ("%video_file%") DO (
set video_file_name=%%~ni%%~xi
set video_ext=%%~xi
)

rmdir /S/Q "!fpska_home!tmp"
mkdir "!fpska_home!tmp"

echo Fpska �������� �����: !fpska_home!
echo.
echo ������ ���� � �����:  !video_file!
echo.

if [%1]==[] (
set method=fast
) else (
set method=%1
)

if [%3]==[] (
set ncpu=4
) else (
set ncpu=%3
)

echo ����� ����������� � 60fps: !method!
echo.

if [!video_file!]==[] (
	echo �� ������ ������� ��� �����
	echo.
	pause
	exit
)

CALL :Check_Install
echo.

echo ����� ������ �����������
echo %time%
echo.

echo --------------------------------------------------------
echo [��� 1/5] ��������� ���������� � ����� � ����� ������� �� ����������
"!fpska_home!ffmpeg\bin\ffprobe.exe" -i "!video_file!" 1>NUL 2> "!fpska_home!tmp\ffprobe.log"

if %errorlevel%==0 (
	echo ���������� ��������� ������� � ���� "!fpska_home!tmp\ffprobe.log"
	echo.
) else (
	echo ������ ���������� ����������
	pause
	exit
)

findstr /m /c:"Audio: aac" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=aac
)

findstr /m /c:"Audio: ac3" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=ac3
)

findstr /m /c:"Audio: mp3" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=mp3
)

findstr /m /c:"Audio: wmav" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=wmav
)

findstr /m /c:"Audio: pcm_" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_pcm=1
)

findstr /m "matroska" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mkv
)


findstr /m /c:"mov,mp4,m4a,3gp,3g2,mj2" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mp4
)

findstr /m /c:"mpegts" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mpegts
)

findstr /m /c:"avi," "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=avi
)

findstr /m /c:"Video: mpeg2video" "!fpska_home!tmp\ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mpeg2
)


if "!audio_pcm!"=="1" (
CALL :PCM_Warning
)




@echo off

echo [��� 2/5] ��������� �������� ������� �� ��������� ����������
if "!container!"=="mp4" (
 if "!audio_codeck!"=="aac" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i "!video_file!" -vn -acodec copy "!fpska_home!tmp\60fps_audio.aac" -v quiet
)
)

if "!audio_codeck!"=="wmav" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i "!video_file!" -vn -acodec copy "!fpska_home!tmp\60fps_audio.wma" -v quiet
)

if "!container!"=="mpeg2" (
 if "!audio_codeck!"=="ac3" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i "!video_file!" -vn -acodec copy "!fpska_home!tmp\60fps_audio.ac3" -v quiet
)
)

if "!container!"=="avi" (
 if "!audio_codeck!"=="mp3" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i "!video_file!" -vn -acodec copy "!fpska_home!tmp\60fps_audio.mp3" -v quiet
)
)

if "!container!"=="mkv" (
copy "!video_file!" "!fpska_home!tmp" >NUL
cd "!fpska_home!tmp" >NUL

"!fpska_home!eac3to\eac3to.exe" "!fpska_home!tmp\!video_file_name!" -demux >NUL
del "!fpska_home!tmp\!video_file_name!" >NUL
del "!fpska_home!tmp\*.txt" >NUL 2>NUL
del "!fpska_home!tmp\*.h264" >NUL 2>NUL
del "!fpska_home!tmp\*.vc1" >NUL 2>NUL

cd "!fpska_home!"

)

if "!container!"=="mpegts" (
copy "!video_file!" "!fpska_home!tmp" >NUL
cd "!fpska_home!tmp"

"!fpska_home!eac3to\eac3to.exe" "!fpska_home!tmp\!video_file_name!" -demux >NUL
del "!fpska_home!tmp\!video_file_name!" >NUL
del "!fpska_home!tmp\*.txt" >NUL 2>NUL
del "!fpska_home!tmp\*.h264" >NUL 2>NUL
del "!fpska_home!tmp\*.vc1" >NUL 2>NUL

cd "!fpska_home!"

)

if %errorlevel%==0 (
	echo �������� ������� ��������� �������
	echo.
) else (
	echo ������ ���������� �������� �������
	pause
	exit
)


echo [��� 3/5] ������� ������ ��� Vapoursynth �� �������

if "!method!"=="slow" (
copy "!fpska_home!scripts\fpska_slow.pvy" "!fpska_home!scripts\work.pvy" >NUL
) else if "!method!"=="lossless" (
copy "!fpska_home!scripts\fpska_slow.pvy" "!fpska_home!scripts\work.pvy" >NUL
) else if "!method!"=="medium" (
copy "!fpska_home!scripts\fpska_medium.pvy" "!fpska_home!scripts\work.pvy" >NUL
) else if "!method!"=="fast" (
copy "!fpska_home!scripts\fpska_fast.pvy" "!fpska_home!scripts\work.pvy" >NUL
)
set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=!video_file!"
set "threads=!ncpu!"

set "textfile=!fpska_home!scripts\work.pvy"
set "newfile=!fpska_home!scripts\tmp.txt"

"!fpska_home!python\python.exe" "!fpska_home!scripts\find_and_replace.py" "fullhd.mkv" "!video_file!" "!textfile!" "!fpska_home!scripts\s.txt" 
"!fpska_home!python\python.exe" "!fpska_home!scripts\find_and_replace.py" "nthreads" "!ncpu!" "!textfile!" "!fpska_home!scripts\s.txt"

"!fpska_home!python\python.exe" "!fpska_home!scripts\setfps.py" "!fpska_home!tmp\ffprobe.log" "!textfile!" "!fpska_home!scripts\s.txt" "!fpska_home!Mediainfo_CLI\MediaInfo.exe" "!video_file!"

if exist "!fpska_home!scripts\work.pvy" (
	echo ������ ��� Vapoursynth ������ �������
	echo.
) else (
	echo ������ �������� Vapoursynth �������
	pause
	exit
)

echo [��� 4/5] ������� ����� � �������� 60 fps
echo ������� ���������� ����������������� ������ (frame):
if "!method!"=="slow" (
"!fpska_home!python\VSPipe.exe" --y4m "!fpska_home!scripts\work.pvy" "-" | "!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 20 -preset slow "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
) else if "!method!"=="medium" (
"!fpska_home!python\VSPipe.exe" --y4m "!fpska_home!scripts\work.pvy" "-" | "!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 24 -preset medium "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
) else if "!method!"=="fast" (
"!fpska_home!python\VSPipe.exe" --y4m "!fpska_home!scripts\work.pvy" "-" | "!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 24 -preset fast "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
)else if "!method!"=="lossless" (
"!fpska_home!python\VSPipe.exe" --y4m "!fpska_home!scripts\work.pvy" "-" | "!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v huffyuv "!fpska_home!tmp\60fps_video.avi" -v quiet -stats
)

if %errorlevel%==0 (
	echo ����� � �������� 60fps c������ ������� "!fpska_home!tmp\60fps_video.mp4"
) else (
	echo ������ �������� ����� � �������� 60 fps
	pause
	exit
)

echo.

echo [��� 5/5] ��������� ����� � �������� �������

del "!fpska_home!tmp\*.log" >NUL 2>NUL

if "!method!"=="lossless" (
	
	if not exist !video_file!_fpska_60fps (
		mkdir !video_file!_fpska_60fps
	) else (
		rmdir /S/Q !video_file!_fpska_60fps
	)
	
	copy !fpska_home!tmp !video_file!_fpska_60fps
    echo ��������������� � 60 fps ���������
	echo ����� � �������� ������� ����������� � !video_file!_fpska_60fps
	pause
	exit
	
	
) else (
	if exist !fpska_home!tmp\60fps_audio.wma (
		echo mkvmerge �� �������� � wma, ������� ������������� �������� ������� � mp3
		!fpska_home!ffmpeg\bin\ffmpeg.exe -i !fpska_home!tmp\60fps_audio.wma -b:a 320k !fpska_home!tmp\60fps_audio.mp3 -v quiet
		del "!fpska_home!tmp\60fps_audio.wma" >NUL 2>NUL
	)


if "!audio_pcm!"=="0" (
	for %%i in ("!fpska_home!tmp\*.*") do set str=!str! "%%i"

"!fpska_home!mkvtoolnix\mkvmerge.exe" !str! -o "!video_file!_fpska_60fps.mkv" >NUL

	if %errorlevel%==0 (
		echo ����� � �������� ������� ���������� �������
	) else (
		echo ������ ��� ����������� ����� � �������� �������
		pause
		exit
	)


rem 	del "!fpska_home!ffprobe.log" >NUL

	del "!video_file!.ffindex" >NUL

	echo �������������� ��������� ����� � ������ 60fps ���������
	echo %time%
	echo.
	echo --------------------------------------------------------
	echo.
	echo ��������� � ������� 60fps: "!video_file!_fpska_60fps.mkv"
	echo.
	
) else if "!audio_pcm!"=="1" (
	echo ��� ��� � ���������� ���������� �������� ������� � ������� PCM,
	echo �� ��������� ������� ����� � ����� ������� �� ���� ���������.
	echo �� ������� ������� ��� ��������������. ��� ����� ��������� � ���������� tmp.
	echo.
	echo �������������� ��������� ����� � ������ 60fps ���������
	echo %time%
	echo.
)

)

endlocal

pause


:Info_Message
echo --------------------------------------------------------
echo. 
echo %~1
echo. 
echo --------------------------------------------------------
EXIT /B 0

:Check_Install

set not_installed=0

if not exist "!fpska_home!eac3to\eac3to.exe" (
	echo eac3to �� �����������, ��������� setup.bat
	set not_installed=1
)

if not exist "!fpska_home!ffmpeg\bin\ffmpeg.exe" (
	echo ffmpeg �� ����������, ��������� setup.bat
	set not_installed=1
)

if not exist "!fpska_home!mkvtoolnix\mkvmerge.exe" (
	echo mkvtoolnix �� �����������, ��������� setup.bat
	set not_installed=1
)

if not exist "!fpska_home!python\vapoursynth64\plugins\svpflow1_vs64.dll" (
	echo svpflow �� �����������, ��������� setup.bat
	set not_installed=1
)

if "!not_installed!"=="1" (
	pause
	exit
)

EXIT /B 0

:PCM_Warning
	echo ��������^^! � ���������� ���������� �������� ������� � ������� PCM.
	echo � ��������� ����� fpsk'� �� ����� ������������ ����� ��� audio.
	echo ������� ����� ������� �������������� � 60fps ��� ������������,
	echo �� ��������� ������� 60fps video � audio ������������ �� �����.
	echo ��� ����� ����� ���������� � ����� tmp.
	echo.
EXIT /B 0

