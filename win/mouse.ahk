#Requires AutoHotkey v2.0

global isDragging := false

; Detect three-finger tap as a trigger (Mouse Button 1 Down)
~LButton::
{
    if (!isDragging) {
        isDragging := true
        CoordMode "Mouse", "Screen"
        MouseGetPos &startX, &startY, &winID
        WinActivate(winID)
        Send("{LButton Down}") ; Simulate holding left-click
    }
}

~LButton Up::
{
    if (isDragging) {
        Send("{LButton Up}") ; Release left-click
        isDragging := false
    }
}

; Move window with pointer while dragging
#HotIf isDragging
MouseMove(x, y, 0) ; Instantly moves window with cursor
#HotIf

