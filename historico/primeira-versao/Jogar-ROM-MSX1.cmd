@echo off
setlocal
set "OPENMSX_USER_DATA=%~dp0..\..\work\msx\emuhome"
start "" "C:\Program Files\openMSX\openmsx.exe" -machine C-BIOS_MSX1 -cart "%~dp0MISTAR_MSX1.ROM" -romtype Normal -script "%~dp0jogar.tcl"
