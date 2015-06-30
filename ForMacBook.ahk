;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HoverScroll() Example Script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
Instructions:

Scroll normally over any window or control to scroll vertically
Hold down Ctrl while scrolling to zoom in/out
Hold down Alt while scrolling to scroll horizontally
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#SingleInstance Force

;Prevent hotkey limit reached warning (500 is just an arbitrarily high number)
#MaxHotkeysPerInterval 500

#Include %A_ScriptDir%
#Include Acc.ahk ;Required for scrolling in MS Office applications
#Include HoverScroll.ahk

ReleaseWait := 300
ReleaseThreshhold := 30
MaxRelease := 1.5
Notches := 0
Notches2 := 0
Direction := 0
TimeSpentScrolling = 0

;Acc.ahk courtesy of AHK user "jethrow", for information please refer to the following thread:
;http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Normal vertical scrolling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WheelUp::
	Lines := ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
	Notches++	
	Notches2 := 0
	direction := -1
	ReleaseThreshhold := Notches*MaxRelease
	SetTimer MoveOn, 100 
	

Return

WheelDown::
	Lines := -ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
	direction := 1	
	Notches2++
	Notches := 0
	ReleaseThreshhold := Notches2*MaxRelease 
	SetTimer MoveOn, 100 
	

Return

MoveOn:
	TimeSpent = 0
     	MouseGetPos,x1,y1

	
	while (ReleaseThreshhold > 0) {
		MouseGetPos,x2,y2 
		Sleep, 1
		HoverScroll((direction))
		ReleaseThreshhold--
		TimeSpent++
		;ToolTip %  Notches
		ToolTip % ReleaseThreshhold ;(Notches + Notches2)
		;ToolTip % Notches2
		if((TimeSpent > (Notches + Notches2))) {
			;ToolTip % TimeSpent
			break
		}

		;if(((x1<>x2) or (y1<>y2)))
		;	break
	}
	Notches := 0
	Notches2 := 0
Return 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Horizontal scrolling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Note: Scrolling direction (left/right) can be inverted by adding a minus sign to Lines.
WheelLeft::
	Lines := -ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines, 0) ;0 = horizontal, 1 (or omit) = vertical
	ToolTip % "<    "
	SetTimer KillToolTip, -300
Return

WheelRight::
	Lines := ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines, 0) ;0 = horizontal, 1 (or omit) = vertical
	ToolTip % "    >"
	SetTimer KillToolTip, -300
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Zooming (Ctrl-Scroll)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;If required, you can split *WheelUp and *WheelDown into hotkeys for Shift, Alt, Ctrl and combinations of these.. In this example we separate the Ctrl-Scroll hotkeys so that different code runs whhen Ctrl is held down, in this case a tooltip is displayed when zooming. We could also pass different parameters to the ScrollLines() function if different acceleration is required when zooming.

;NOTE: For zooming scrolling more than 1 line per notch can cause target control to scroll vertically as well, so I suggest using a value of 1.

;Zoom IN
^WheelUp::
	Lines := -1
	HoverScroll(Lines,,1)
	ToolTip % "IN"
	SetTimer KillToolTip, -400
Return

;Zoom OUT
^WheelDown::
	Lines := 1
	HoverScroll(Lines,,1)
	ToolTip % "OUT"
	SetTimer KillToolTip, -400
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;All other modifiers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;NOTE: Although in theory *WheelUp already includes ^WheelUp, ^WheelUp takes precedence because it appears first in the script (above *WheelUp). The same applies to WheelDown, so you don't need to worry about duplicate hotkeys.

*WheelUp::
	Lines := ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return

*WheelDown::
	Lines := -ScrollLines_3(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

KillToolTip:
	Tooltip
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
