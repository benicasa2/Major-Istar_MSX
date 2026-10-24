@echo off
setlocal
set "OPENMSX_USER_DATA=%~dp0..\..\work\msx\emuhome"
start "" "C:\Program Files\openMSX\openmsx.exe" -machine MISTAR_MSX1 -diska "%~dp0MISTAR_MSX1.DSK" -script "%~dp0jogar.tcl"
