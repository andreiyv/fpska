@echo off
chcp 1251
pushd %~dp0
cls

set not_installed=0

if not exist ".\eac3to\eac3to.exe" (
	echo eac3to не установлена, запустите setup.bat
	set not_installed=1
)

if not exist ".\ffmpeg\bin\ffmpeg.exe" (
	echo ffmpeg не установлен, запустите setup.bat
	set not_installed=1
)

if not exist ".\mkvtoolnix\mkvmerge.exe" (
	echo mkvtoolnix не установлены, запустите setup.bat
	set not_installed=1
)

if not exist ".\python\vapoursynth64\plugins\svpflow1_vs64.dll" (
	echo svpflow не установлена, запустите setup.bat
	set not_installed=1
)

if %not_installed%==1 (
	pause
	exit
)

cd scripts
..\python\python.exe fpska_gui.py
rem %~dp0python\python.exe %~dp0scripts\fpska_gui.py
if %errorlevel%==0 (
    exit
) else (
    pause
)
