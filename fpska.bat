chcp 1251
@echo off &setlocal
setlocal enabledelayedexpansion

cls

CALL :Info_Message "fpska v0.6 - скрипт для конвертации в 50/60 FPS"

set fpska_home=%~dp0
set ffmpeg_threads=1
set method=slow
set ncpu=2
set container=""
set audio_codeck=""
set audio_pcm=0
set video_file=%~f2
set video_ext=%~x2
set video_file_name=%~n2

echo Fpska домашняя папка: !fpska_home!
echo.
echo Полный путь к файлу:  !video_file!
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

echo Метод конвертации в 50/60fps: !method!
echo.

if [!video_file!]==[] (
	echo Вы забыли указать имя файла
	echo.
	pause
	exit
)

CALL :Check_Install
echo.

echo Время начала кодирования
echo %time%
echo.

echo --------------------------------------------------------
echo [Шаг 1/5] Извлекаем информацию о видео и аудио кодеках из видеофайла
"!fpska_home!ffmpeg\bin\ffprobe.exe" -i "!video_file!" 1>NUL 2> "!fpska_home!ffprobe.log"

if %errorlevel%==0 (
	echo Информация извлечена успешно в файл "!fpska_home!ffprobe.log"
	echo.
) else (
	echo Ошибка извлечения информации
	echo Проверьте есть ли в имени видеофайла пробелы, русские буквы, скобки, 
	echo восклицательные знаки и т.д. В настоящей версии они не поддерживаются
	echo Переименуйте пожалуйста исходный видеофайл
	pause
	exit
)

findstr /m /c:"Audio: aac" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=aac
)

findstr /m /c:"Audio: mp3" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_codeck=mp3
)

findstr /m /c:"Audio: pcm_" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set audio_pcm=1
)

findstr /m "matroska" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mkv
)

rem findstr /m /c:"Video: h264" "!fpska_home!ffprobe.log" >NUL
rem if %errorlevel%==0 (
rem 	set container=mp4
rem )

findstr /m /c:"mov,mp4,m4a,3gp,3g2,mj2" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mp4
)

findstr /m /c:"mpegts" "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=mpegts
)

findstr /m /c:"avi," "!fpska_home!ffprobe.log" >NUL
if %errorlevel%==0 (
	set container=avi
)

if "!audio_pcm!"=="1" (
CALL :PCM_Warning
)



rmdir /S/Q "!fpska_home!tmp"
mkdir "!fpska_home!tmp"

@echo off

echo [Шаг 2/5] Извлекаем звуковую дорожку из исходного видеофайла
if "!container!"=="mp4" (
 if "!audio_codeck!"=="aac" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i !video_file! -vn -acodec copy "!fpska_home!\tmp\60fps_audio.aac" -v quiet
)
)

if "!container!"=="avi" (
 if "!audio_codeck!"=="mp3" ( 
"!fpska_home!ffmpeg\bin\ffmpeg.exe" -y -i !video_file! -vn -acodec copy "!fpska_home!\tmp\60fps_audio.mp3" -v quiet
)
)

if "!container!"=="mkv" (
copy "!video_file!" "!fpska_home!\tmp" >NUL
cd "!fpska_home!\tmp" >NUL

"!fpska_home!eac3to\eac3to.exe" "!fpska_home!tmp\!video_file_name!!video_ext!" -demux >NUL
del "!fpska_home!\tmp\!video_file_name!!video_ext!" >NUL
del "!fpska_home!\tmp\*.txt" >NUL 2>NUL
del "!fpska_home!\tmp\*.h264" >NUL 2>NUL
del "!fpska_home!\tmp\*.vc1" >NUL 2>NUL

cd "!fpska_home!"

)

if "!container!"=="mpegts" (
copy "!video_file!" "!fpska_home!\tmp" >NUL
cd "!fpska_home!\tmp"

"!fpska_home!eac3to\eac3to.exe" "!fpska_home!\tmp\!video_file_name!!video_ext!" -demux >NUL
del "!fpska_home!\tmp\!video_file_name!!video_ext!" 
del "!fpska_home!\tmp\*.txt" >NUL 2>NUL
del "!fpska_home!\tmp\*.h264" >NUL 2>NUL
del "!fpska_home!\tmp\*.vc1" >NUL 2>NUL

cd "!fpska_home!"

)

if %errorlevel%==0 (
	echo Звуковая дорожка извлечена успешно
	echo.
) else (
	echo Ошибка извлечения звуковой дорожки
	pause
	exit
)


echo [Шаг 3/5] Создаем скрипт для Vapoursynth из шаблона

if "!method!"=="slow" (
copy "!fpska_home!\scripts\fpska_slow.pvy" "!fpska_home!\scripts\work.pvy" >NUL
) else if "!method!"=="medium" (
copy "!fpska_home!\scripts\fpska_medium.pvy" "!fpska_home!\scripts\work.pvy" >NUL
) else if "!method!"=="fast" (
copy "!fpska_home!\scripts\fpska_fast.pvy" "!fpska_home!\scripts\work.pvy" >NUL
)
set "search=fullhd.mkv"
set "search_threads=nthreads"
set "replace=!video_file!"
set "threads=!ncpu!"

set "textfile=!fpska_home!\scripts\work.pvy"
set "newfile=!fpska_home!\scripts\tmp.txt"

(for /f "delims=" %%i in (%textfile%) do (
    set "line=%%i"
    set "line=!line:%search%=%replace%!"
    set "line=!line:%search_threads%=%threads%!"
    echo(!line!
))>"%newfile%"
del "!fpska_home!\scripts\work.pvy"
ren "!fpska_home!\scripts\tmp.txt" "work.pvy"

if exist "!fpska_home!scripts\work.pvy" (
	echo Скрипт для Vapoursynth создан успешно
	echo.
) else (
	echo Ошибка создания Vapoursynth скрипта
	pause
	exit
)

echo [Шаг 4/5] Создаем видео с частотой 50/60fps
if "!method!"=="slow" (
"!fpska_home!\python\VSPipe.exe" --y4m "!fpska_home!\scripts\work.pvy" "-" | "!fpska_home!\ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 20 -preset slow "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
) else if "!method!"=="medium" (
"!fpska_home!\python\VSPipe.exe" --y4m "!fpska_home!\scripts\work.pvy" "-" | "!fpska_home!\ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 20 -preset slow "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
) else if "!method!"=="fast" (
"!fpska_home!\python\VSPipe.exe" --y4m "!fpska_home!\scripts\work.pvy" "-" | "!fpska_home!\ffmpeg\bin\ffmpeg.exe" -y -i pipe: -c:a copy -c:v libx264 -crf 28 -preset slow "!fpska_home!tmp\60fps_video.mp4" -v quiet -stats
)

if %errorlevel%==0 (
	echo видео с частотой 50/60fps cоздано успешно "!fpska_home!tmp\60fps_video.mp4"
	echo.
) else (
	echo Ошибка создания видео с частотой 50/60fps
	pause
	exit
)

echo.

echo [Шаг 5/5] Склеиваем видео и звуковую дорожки
if "!audio_pcm!"=="0" (
	for %%i in ("!fpska_home!tmp\*.*") do set str=!str! "%%i"

rem 	echo mkvmerge: !str!

	"!fpska_home!\mkvtoolnix\mkvmerge.exe" !str! -o "!video_file!_fpska_60fps.mkv" >NUL
	
	if %errorlevel%==0 (
		echo видео и звуковая дорожки объеденены успешно
		echo.
	) else (
		echo Ошибка при объединении видео и звуковой дорожки
		pause
		exit
	)

	del !fpska_home!\ffprobe.log >NUL

	echo Преобразование исходного видео в формат 50/60fps закончено
	echo %time%
	echo.
	echo --------------------------------------------------------
	echo.
	echo Видеофайл в формате 50/60fps: "!video_file!_fpska_60fps.mkv"
	echo.
	
) else if "!audio_pcm!"=="1" (
	echo Так как в видеофайле содержится звуковая дорожка в формате PCM,
	echo то финальная склейка видео и аудио дорожек не была проведена.
	echo Вы сможете сделать это самостоятельно. Все файлы находятся в директории tmp.
	echo.
	echo Преобразование исходного видео в формат 50/60fps закончено
	echo %time%
	echo.
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
	echo eac3to не установлена, запустите setup.bat
	set not_installed=1
)

if not exist "!fpska_home!ffmpeg\bin\ffmpeg.exe" (
	echo ffmpeg не установлен, запустите setup.bat
	set not_installed=1
)

if not exist "!fpska_home!mkvtoolnix\mkvmerge.exe" (
	echo mkvtoolnix не установлены, запустите setup.bat
	set not_installed=1
)

if not exist "!fpska_home!python\vapoursynth64\plugins\svpflow1_vs64.dll" (
	echo svpflow не установлена, запустите setup.bat
	set not_installed=1
)

if "!not_installed!"=="1" (
	pause
	exit
)

EXIT /B 0

:PCM_Warning
	echo Внимание^^! В видеофайле содержится звуковая дорожка в формате PCM.
	echo В настоящее время fpsk'а не может обрабатывать такой тип audio.
	echo Поэтому будет сделано преобразование в 60fps для видеодорожки,
	echo но финальная склейка 60fps video и audio производится не будет.
	echo Все файлы будут находиться в папке tmp.
	echo.
EXIT /B 0

