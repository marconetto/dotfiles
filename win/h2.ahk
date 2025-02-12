#Requires AutoHotkey v2.0

CapsLock::{
    KeyWait("CapsLock", "T0.2") ; Wait 0.2s to check if CapsLock is held
    if (ErrorLevel) { ; If held, send Hyper Key (Ctrl + Shift + Alt + Win)
        Send("{Ctrl Down}{Shift Down}{Alt Down}{LWin Down}")
        KeyWait("CapsLock") ; Wait for release
        Send("{Ctrl Up}{Shift Up}{Alt Up}{LWin Up}")
    } else { ; If tapped, send Esc
        Send("{Esc}")
    }
}

; Prevent CapsLock from toggling on/off
SetCapsLockState("AlwaysOff")

