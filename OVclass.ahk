#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Pixelmittesuche(x, y, fieldofview,Farbe,Farbvariante )
{
	global bneuy
	global bneux


PixelSearch, x1x, y1y,x, y, x+fieldofview, y-fieldofview, Farbe, Farbvariante, FAST RGB
		If !ErrorLevel 
		{
				ex1x:=distance(x, y, x1x, y1y)
				ex1xergebnis=%ex1x%/%x1x%/%y1y%
		}

;2		
PixelSearch, x2x, y2y,x, y, x-fieldofview, y-fieldofview, Farbe, Farbvariante, FAST RGB
		If !ErrorLevel 
		{
				ex2x:=distance(x, y, x2x, y2y)
				ex2xergebnis=%ex2x%/%x2x%/%y2y%
		}		

		
;8	
PixelSearch, x8x, y8y,x, y, x+fieldofview, y+fieldofview, Farbe, Farbvariante, FAST RGB
		If !ErrorLevel 
		{
				ex8x:=distance(x, y, x8x, y8y)
				ex8xergebnis=%ex8x%/%x8x%/%y8y%	
		}		
		
;9		
PixelSearch, x9x, y9y,x, y, x-fieldofview, y+fieldofview, Farbe, Farbvariante, FAST RGB
		If !ErrorLevel 
		{
				ex9x:=distance(x, y, x9x, y9y)
				ex9xergebnis=%ex9x%/%x9x%/%y9y%
		}		

			
		

AlleVar = %ex1x%,%ex2x%,%ex8x%,%ex9x%
Sort AlleVar, N D,  

StringSplit, bestexArrax, AlleVar, `,



Loop, %bestexArrax0%
{

    bestex := bestexArrax%A_Index%

	if bestex !=
	{
	break
    }
}	


if bestex =
goto leer




If InStr(ex1xergebnis, bestex)
	{

   StringSplit, besteyArray, ex1xergebnis, `/
   bneux:=besteyArray2-x
   bneuy:=besteyArray3-y 
	auswahl=1
   goto bestegefunden
	}

If InStr(ex2xergebnis, bestex)
   {

    StringSplit, besteyArray, ex2xergebnis, `/
   bneux:=besteyArray2-x
   bneuy:=besteyArray3-y
   auswahl=2
	goto bestegefunden   
	}

If InStr(ex8xergebnis, bestex)
   {

   StringSplit, besteyArray, ex8xergebnis, `/
   bneux:=besteyArray2-x
   bneuy:=besteyArray3-y 
   auswahl=8
	goto bestegefunden   
	}

If InStr(ex9xergebnis, bestex)
   {

   StringSplit, besteyArray, ex9xergebnis, `/
   bneux:=besteyArray2-x
   bneuy:=besteyArray3-y
   auswahl=9
	goto bestegefunden
   }
    
	leer:
	bneux:=
    bneuy:=
	auswahl=
	

	bestegefunden:

	return   
}




distance(x1, y1, x2, y2) {
    return Sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
}




Canvas_DrawLine(hWnd, p_x1, p_y1, p_x2, p_y2, p_w, p_color) ; r,angle,width,color)
   {
   VarSetCapacity(Rect, 16, 0) 
   p_x1 -= 1, p_y1 -= 1, p_x2 -= 1, p_y2 -= 1
   hDC := DllCall("GetDC", UInt, hWnd)
   hCurrPen := DllCall("CreatePen", UInt, 0, UInt, p_w, UInt, 0xFFFFFF)
   DllCall("SelectObject", UInt,hdc, UInt,hCurrPen)
   DllCall("gdi32.dll\MoveToEx", UInt, hdc, Uint,p_x1, Uint, p_y1, Uint, 0 )
   DllCall("gdi32.dll\LineTo", UInt, hdc, Uint, p_x2, Uint, p_y2 )
   DllCall("ReleaseDC", UInt, 100, UInt, hDC)  ; Clean-up.
   DllCall("DeleteObject", UInt,hCurrPen)
   DllCall("ReleaseDC", UInt, 100, UInt, hDC)
	

   }


   
 mcircle() { 
	Gui, mcircle: Margin, 0, 0
   	Gui, mcircle: Color, 0xFFFFFF
	Gui, mcircle: Add, Picture,AltSubmit x0 y0 center, img/mcircle.bmp
	Gui, mcircle: -Caption +AlwaysOnTop +ToolWindow +LastFound
	Gui, mcircle: Show, w35 h35 NoActivate  , mcircle
	WinSet, TransColor,0xFFFFFF ,mcircle
	WinSet, AlwaysOnTop , , mcircle
	WinMove , mcircle, ,,A_ScreenHeight/2*9,
	return
	}
	

 CrossHair (d := 8) 
	{ 
	Gui, CrossHair: New, +AlwaysOnTop -Caption +LastFound -SysMenu +ToolWindow +E0x20
	Gui, CrossHair: Margin, 0, 0
	Gui, CrossHair: Color, aqua
	Gui, CrossHair: Show, % "w"d " h"d " x"(A_ScreenWidth//2-(d//2)) " y" (A_ScreenHeight//2-(d//2)) ,CrossHair
	WinSet, Region, 0-0 W%d% H%d% E,CrossHair
	WinMove , CrossHair, ,,A_ScreenHeight/2*9,
	}





	
	
GuiOverlay() {
Gui, 1:+AlwaysOnTop +ToolWindow +LastFound 
Gui, 1:-Caption
Gui, 1:Color, 000000
WinSet, TransColor, 000000
GuiHwnd := WinExist()
Gui, 1:Show,,GuiOverlay
Gui, 1:Maximize

return GuiHwnd

}



makeCircle(color, r := 50, thickness := 10, transparency := 254,weitenk :=0 ) {
	static HWND := MakeGui()
	d := 2 * r
	x :=A_ScreenWidth/2-r
	y :=A_ScreenHeight/2-r-weitenk
		
	; https://autohotkey.com/board/topic/7377-create-a-transparent-circle-in-window-w-winset-region/
	outer := DllCall("CreateEllipticRgn", "Int", 0, "Int", 0, "Int", d, "Int", d)
	inner := DllCall("CreateEllipticRgn", "Int", thickness, "Int", thickness, "Int", d - thickness, "Int", d - thickness)
	DllCall("CombineRgn", "UInt", outer, "UInt", outer, "UInt", inner, "Int", 3) ; RGN_XOR = 3
	DllCall("SetWindowRgn", "UInt", HWND, "UInt", outer, "UInt", true)

	Gui %HWND%:Color, % color
	Gui %HWND%:Show, x%x% y%y% w%d% h%d% NoActivate
	WinSet Transparent, % transparency, % "ahk_id " HWND
    
	return HWND
}

MakeGui() {
	Gui New, +E0x20 +AlwaysOnTop +ToolWindow -Caption +Hwndhwnd
	
	return hwnd
}

MsiMessageBox(Text, Title := "", Options := 0, Owner := 0) {
    Ret := DllCall("msi.dll\MsiMessageBox"
        , "Ptr" , Owner
        , "Str" , Text
        , "str" , Title
        , "UInt", Options
        , "UInt", 0)
    Return {1: "OK", 2: "Cancel", 3: "Cancel", 4: "Retry", 5: "Ignore", 6: "Yes", 7: "No", 10: "Try Again"}[Ret]
}








ESPBox(x, y, FOVpixel,Farbe,Farbvariante,transparency,ESPon,distanceon) {
static clean
static entfernung


IfWinNotExist,ESPGui
	{
	Gui, ESPGui:  Font, s10 q2,Arial
	Gui, ESPGui: -Caption +AlwaysOnTop +ToolWindow +LastFound
	Gui, ESPGui: Margin, 1, 1
   	Gui, ESPGui: Color, 0xf6f6f6
	Gui, ESPGui: Add, text, vclean cgree +BackgroundWhite x1 y1 w1 h1 0x6,
	;Gui, ESPGui: Add, text, cf6f6f6  +BackgroundTrans ventfernung   x1 y1 ,149 m
	Gui, ESPGui: Show,% w1 h1 x0 y0 NoActivate  ,ESPGui
	WinSet, TransColor,White %transparency%,ESPGui
	
	
	Gui, entfe:  Font, s10 q4,Arial
	Gui, entfe: -Caption +AlwaysOnTop +ToolWindow +LastFound
	Gui, entfe: Margin, 1, 1
	Gui, entfe: Color, White
	;Gui, entfe: Add, text, vclean cgree +BackgroundWhite x1 y1 w1 h1 0x6,
	Gui, entfe: Add, text, cf6f6f6  +BackgroundTrans ventfernung  w200  x1 y1 ,149 m
	Gui, entfe: Show,% w221 h1 x0 y0 NoActivate ,entfe
	WinSet, TransColor,White %transparency%,entfe

	}
	WinSet, TransColor,White %transparency%,ESPGui


	PixelSearch, ESPx, ESPy,x-FOVpixel, y-FOVpixel, x+FOVpixel, y+FOVpixel, Farbe, Farbvariante, FAST RGB
	If !ErrorLevel
	{
			PixelSearch, ESPx2, ESPy2,ESPx+FOVpixel, ESPy+FOVpixel, ESPx-FOVpixel, ESPy-FOVpixel, Farbe, Farbvariante, FAST RGB
			If !ErrorLevel
			{

			ESPhohe:=ESPy2-ESPy
			ESPbreite:=ESPhohe/8*2
			
						
			if ESPbreite > ESPhohe
				ESPbreite:=ESPhohe
				
				
			ergebnis:=	4500/ESPhohe
			ergebnis:= % Round(ergebnis, -1)
				
			
			if distanceon=1
			{
				GuiControl, entfe:Text, entfernung ,%ergebnis% m
				GuiControl, entfe: Move, entfernung,% "y" ESPhohe-15
				WinMove ,entfe, ,ESPx-ESPbreite,ESPy+15,ESPbreite+ESPbreite+250,ESPhohe
			}
			
			
			if ESPon=1
				{
				GuiControl, ESPGui: Move, clean,% "w" ESPbreite+ESPbreite-2  "h"ESPhohe-2-0
				WinMove , ESPGui, ,ESPx-ESPbreite,ESPy,ESPbreite+ESPbreite,ESPhohe
				}
			
			}
	}

	if ESPhohe=
		{
		WinMove , ESPGui, ,0,0,0,0
		WinMove , entfe, ,0,0,0,0
		}
	return ESPhohe, ESPbreite
	



}
