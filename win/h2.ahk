#Requires AutoHotkey v2.0

CapsLock::{
    held := KeyWait("CapsLock", "T0.2") ; Returns TRUE if released before timeout
    if (!held) { ; If held, send Hyper Key (Ctrl + Shift + Alt + Win)
        Send("{Ctrl Down}{Shift Down}{Alt Down}{LWin Down}")
        KeyWait("CapsLock") ; Wait for release
        Send("{Ctrl Up}{Shift Up}{Alt Up}{LWin Up}")
    } else { ; If tapped, send Esc
        Send("{Esc}")
    }
}

; Prevent CapsLock from toggling on/off
SetCapsLockState("AlwaysOff")

