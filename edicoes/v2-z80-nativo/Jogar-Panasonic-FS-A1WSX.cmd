@echo off
setlocal
set "OPENMSX_USER_DATA=%~dp0..\..\work\msx\emuhome"
start "" "C:\Program Files\openMSX\openmsx.exe" -machine Panasonic_FS-A1WSX -cart "%~dp0MISTAR_MSX2PLUS_Z80_TURBO.ROM" -romtype Normal -script "%~dp0jogar.tcl"
