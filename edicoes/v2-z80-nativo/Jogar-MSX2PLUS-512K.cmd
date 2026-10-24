@echo off
setlocal
set "OPENMSX_USER_DATA=%~dp0..\..\work\msx\emuhome"
start "" "C:\Program Files\openMSX\openmsx.exe" -machine MISTAR_MSX2PLUS_512K -cart "%~dp0MISTAR_MSX2PLUS_Z80_TURBO.ROM" -romtype Normal -script "%~dp0jogar.tcl"
