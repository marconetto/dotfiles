

; -------------------------------------------------------------------
#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force



SendMode Input



;; deactivate capslock completely
SetCapslockState, AlwaysOff


;; remap capslock to hyper
;; if capslock is toggled, remap it to esc


;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; must use downtemp to emulate hyper key, you cannot use down in this case
    ;; according to https://autohotkey.com/docs/commands/Send.htm, downtemp is as same as down except for ctrl/alt/shift/win keys
    ;; in those cases, downtemp tells subsequent sends that the key is not permanently down, and may be
    ;; released whenever a keystroke calls for it.
    ;; for example, Send {Ctrl Downtemp} followed later by Send {Left} would produce a normal {Left}
    ;; keystroke, not a Ctrl{Left} keystroke
    Send {RAlt DownTemp}{LWin DownTemp}{RControl DownTemp}
    KeyWait, Capslock
    Send {RAlt Up}{LWin Up}{RControl Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return


;; vim navigation with hyper
~Capslock & h:: Send {Left}
~Capslock & l:: Send {Right}
~Capslock & k:: Send {Up}
~Capslock & j:: Send {Down}



;; popular hotkeys with hyper
~Capslock & c:: Send ^{c}
~Capslock & v:: Send ^{v}


~Capslock & 1:: Send {F1}
~Capslock & 2:: Send {F2}
~Capslock & 3:: Send {F3}
~Capslock & 4:: Send {F4}
~Capslock & 5:: Send {F5}
~Capslock & 6:: Send {F6}
~Capslock & 7:: Send {F7}
~Capslock & 8:: Send {F8}
~Capslock & 9:: Send {F9}
~Capslock & 0:: Send {F10}

