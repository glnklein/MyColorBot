﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
PID := DllCall("GetCurrentProcessId") ;PID Of Script
Process, Priority, %PID%, Above HIGH
SetControlDelay, -1
SetBatchLines, -1
SetWinDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
DetectHiddenWindows, On
#NoTrayIcon

;#include debugv2.ahk
#include OVclass.ahk
#include CaptureScreen.ahk
Debug_console =1
Version=1.01
gosub Help



if !FileExist("\img\mcircle.bmp")
{
FileCreateDir, %A_ScriptDir%\img
FileInstall,img\mcircle.bmp, %A_ScriptDir%\img\mcircle.bmp, 1
}


x :=A_ScreenWidth/2
y :=A_ScreenHeight/2
sw :=A_ScreenWidth-400
FOV=0
te:=0
ShowWin =1
tcolor    = 00FF00

iniRead, TargetButton, config.ini, Keys,TargetButton
iniRead, Farbe, config.ini, Color,color_selected
iniRead, FOVpixel, config.ini, FOV,FOVpixel


Gui, me:  Font, s8
Gui, me:  Add, GroupBox, x10 y20 w275 h245, Bot Settings
Gui, me:  +AlwaysOnTop +ToolWindow +LastFound +SysMenu
Gui, me:  Font, s10
Gui, me:  Add, CheckBox, x20 y50  h25   vqbot,   Qbot
Gui, me:  Add, CheckBox, x120 y+-25  h25  vautofire,  Autofire
Gui, me:  Add, Text, x20 y+10 w100 vsmoothingtext, Smoothing       %smoothing%    
Gui, me:  Add, Slider,x15 y+1 h30  w180 +BackgroundTrans vsmoothing Range1-40  , 4
Gui, me:  Add, Text, x20 y+10 w150 vdeadzonetext, Deadzone        %deadzone%    
Gui, me:  Add, Slider,x15 y+1 h30  w180 +BackgroundTrans vdeadzone Range2-50  , 8
Gui, me:  Add, Text, x20 y+10  , TargetKey
Gui, me:  Add, Hotkey, x20 y+5 , %TargetButton%


Gui, me:  Font, s8
Gui, me:  Add, GroupBox, x10 w275 h310 y+30, Visual
Gui, me:  Font, s10
Gui, me:  Add, CheckBox, x20 y+-290  h25  gFOV vFOV,  Field of View
Gui, me:  Add, Text, x20 y+10 w150 vFOVpixeltext, Field of View   %FOVpixel%    
Gui, me:  Add, Slider,x15 y+1 h30 w180 +BackgroundTrans vFOVpixel Range5-350  , 200 
Gui, me:  Add, Text, x20 y+10 w200 vFOVTranstext , Field of View Transparents %FOVTrans%
Gui, me:  Add, Slider,x15 y+1 h30 w180 +BackgroundTrans vFOVTrans Range5-255  ,60
Gui, me:  Add, Text, x20 y+10 w220 vweitenktext,Field of View height correction   %weitenk%    
Gui, me:  Add, Slider,x15 y+5  w150 +BackgroundTrans vweitenk Range-30-30  , 0
Gui, me:  Add, CheckBox, x20 y+10 h25 gscancircle vscancircle,  Scan Circle 
Gui, me:  Add, CheckBox, x120 y+-25  h25 vtargetline, Target Line 
Gui, me:  Add, CheckBox, x20 y+10  h25 gCrossHair vCrossHair, CrossHair
Gui, me:  Add, CheckBox, x120 y+-25  h25 Checked vPermaScan, PermaScan


Gui, me:  Font, s8
Gui, me:  Add, GroupBox, x10 w275 h200 y+30, Color
Gui, me:  Font, s10
Gui, me:  Add, Text,h22 x50 y+-170, PIC Color (STRG+X)
Gui, me:  Add, Progress,x20 y+-23 w22 h22  Disabled Backgroundgreen
Gui, me:  Add, Progress,x22 y+-20 w18 h18  Disabled Background%Farbe% vpiccolor2
Gui, me:  Add, Text, x20 y+15  h10, Direct Color
Gui, me:  Add, DropDownList, x20 y+5  h115  vdirectcolor,Color||K5S2|Orange|DMR|Rot|
Gui, me:  Add, Text, x20 y+20 w120 vFarbvariantetext, Colour variant  %Farbvariante%    
Gui, me:  Add, Slider,x15 y+1 h30  w180 +BackgroundTrans vFarbvariante Range1-200 , 74


Gui, me:  Show, w300 h810 x%sw%,MyColorBot

WinWait , MyColorBot ;

meID := WinExist("MyColorBot")
Random, newme , 11111111, 999999999
WinSetTitle,  ahk_id %meID%, ,- %newme% Help with F1 ; Set new Windows Name for 

GuiHwnd := GuiOverlay()
mcircleHwnd := mcircle()
gosub StartControl
SetTimer ,controls ,1
return


controls:
Gui,me:  Submit , NoHide
IfWinNotActive, ahk_id %meID%
	{
	allscan:=scancircle+targetline
	
		if qbot=1
			gosub qbotrun
		
	
	
	

		if allscan between 1 and 2
			gosub Scanner
	
	}	
		
StartControl:
IfWinActive , ahk_id %meID%
	{
	
	WinSet, Redraw,, ahk_id %GuiHwnd%
	
	Gui,me:  Submit , NoHide
	GuiControl,me:, smoothingtext,Smoothing       %smoothing%    
	GuiControl,me:, deadzonetext, Deadzone        %deadzone%    
	GuiControl,me:, FOVpixeltext, Field of View   %FOVpixel%    
	GuiControl,me:, FOVTranstext,  Field of View Transparents %FOVTrans%
	GuiControl,me:, weitenktext,  Field of View height correction   %weitenk%    
	GuiControl,me:, Farbvariantetext, Colour variant  %Farbvariante%    
	y :=A_ScreenHeight/2-weitenk
	WinMove , mcircle, ,A_ScreenWidth*5,A_ScreenWidth*5,
	
	if FOV=1 
		 gosub FOV 
	

	}

return




qbotrun:
Target := GetKeyState(TargetButton)

if Target=1
{
WinMove , mcircle, ,A_ScreenWidth*5,A_ScreenWidth*5,
Pixelmittesuche(x, y, FOVpixel-3,Farbe,Farbvariante)


		if bneux !=
		{
			smoothing :=smoothing
			loopx :=bneux/smoothing
			loopy :=bneuy/smoothing
			
			loop,%smoothing%
			{	
			DllCall("mouse_event", "UInt", 0x01, "UInt", loopx, "UInt", loopy, uint, 100, int, 100)
			
			PixelSearch, Px2, Py2,x-deadzone-3, y-deadzone, x+deadzone-3, y+deadzone, Farbe, Farbvariante*2, FAST RGB
			
			if Px2 !=
				{
				DllCall("mouse_event", "UInt", 0x01, "UInt",Px2-x+3 , "UInt", Py2-y+3, uint, 1, int, 1)
				
					if autofire =1
						MouseClick, left
				
				
				Px2 =
				break
				}	
						

			}


		}

}

bneux =
bneuy =


return

Scanner:
Target := GetKeyState(TargetButton)
WinSet, Redraw,, ahk_id %GuiHwnd%

if Target=0
{

 MouseRButton := GetKeyState("RButton")

	if PermaScan = 1
		MouseRButton = 1 

	if MouseRButton = 1 
			{
		Pixelmittesuche(x, y, FOVpixel-3,Farbe,Farbvariante)
	}
		if bneux =
			WinMove , mcircle, ,A_ScreenWidth*5,A_ScreenWidth*5,
			
	
		if bneux !=
			{
			if scancircle = 1
				{ 
				WinMove , mcircle, ,bneux+x-18,bneuy+y-17,
				WinSet, AlwaysOnTop , , mcircle 
				}
			
			if targetline = 1
				Canvas_DrawLine(GuiHwnd, x, y*2, bneux+x, bneuy+y+15, 1, tcolor)
			
			
			

					
			}

}
bneux =
bneuy =

if Target=1
WinMove , mcircle, ,A_ScreenWidth*5,A_ScreenWidth*5,

return







fov:
Gui,me:  Submit , NoHide

if FOV=1
	{
	ta:=FOVpixel+weitenk+FOVTrans
		if ta != %te%
		{
		IniWrite, %FOVpixel%, config.ini, FOV,FOVpixel
		hCircle := makeCircle(0xFFFFFF, r := FOVpixel+5, 2, FOVTrans,weitenk)
		te:=FOVpixel+weitenk+FOVTrans
		IniWrite, %FOVpixel%, config.ini, FOV,FOVpixel
		if CrossHair=1
		WinMove , CrossHair, ,,A_ScreenHeight/2-weitenk,
		
		}
	}

	
if FOV=0
	Gui, %hCircle%: submit
	te:=0
	
return


scancircle:
Gui,me:  Submit , NoHide

 if scancircle=1
	Gui, mcircle: submit, NoHide
	

 if scancircle=0
	WinMove , mcircle, ,,A_ScreenHeight/2*9,
	
return	


CrossHair:
Gui,me:  Submit , NoHide

	if CrossHair=0
		WinMove , CrossHair, ,,A_ScreenHeight/2*3,

	
	if CrossHair=1
		WinMove , CrossHair, ,,A_ScreenHeight/2-weitenk,

return





F1::
Help:
Text := "`nF12 = Create Screenshot `n`nINSERT = Hidden/Show menu `n`nSTRG+X = Apply color under mouse cursor `n`nEND = EXIT Bot`n`nEdit Config in config.ini n`n"

MsiMessageBox(Text, "MyColorBot v"Version, 0x40)

return


















F12::
soundbeep
CaptureScreen(" 660, 240, 1250,850 ")
sleep,3000
run , screen.bmp
sleep,3000
FileDelete ,screen.bmp

return


^x::  ; Hotkey STRG+ALT+Z.
MouseGetPos, MausX, MausY
PixelGetColor, Farbe, %MausX%, %MausY% ,RGB
GuiControl, me:+Background%hauptguicolor%,MeinFortschritt,
GuiControl, me:+Background%Farbe%,piccolor2,
IniWrite, %Farbe%, config.ini, Color,color_selected

return

Insert::
if ShowWin =1
{
WinHide , ahk_id %meID%
ShowWin =0
return
}

if ShowWin =0
{
WinShow , ahk_id %meID%
ShowWin =1
return
}


return



END::
Exitapp