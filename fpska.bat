@echo off
chcp 1251
pushd %~dp0
cls

set not_installed=0

if not exist ".\eac3to\eac3to.exe" (
	echo eac3to �� �����������, ��������� setup.bat
	set not_installed=1
)

if not exist ".\ffmpeg\bin\ffmpeg.exe" (
	echo ffmpeg �� ����������, ��������� setup.bat
	set not_installed=1
)

if not exist ".\mkvtoolnix\mkvmerge.exe" (
	echo mkvtoolnix �� �����������, ��������� setup.bat
	set not_installed=1
)

if not exist ".\python\vapoursynth64\plugins\svpflow1_vs64.dll" (
	echo svpflow �� �����������, ��������� setup.bat
	set not_installed=1
)

if %not_installed%==1 (
	pause
	exit
)

%~dp0python\python.exe %~dp0scripts\fpska_gui.py
if %errorlevel%==0 (
    exit
) else (
    pause
)
