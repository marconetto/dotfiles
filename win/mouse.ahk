#Requires AutoHotkey v2.0

global isDragging := false
global startX := 0, startY := 0, winID := 0

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
~MouseMove::
{
    if (isDragging) {
        MouseGetPos &newX, &newY
        dx := newX - startX
        dy := newY - startY
        startX := newX
        startY := newY
        WinMove(winID,,, A_ScreenWidth + dx, A_ScreenHeight + dy)
    }
}
#HotIf

