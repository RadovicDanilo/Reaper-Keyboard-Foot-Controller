#Persistent
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk

AHI := new AutoHotInterception()
global SendToEverything := false 
global KeyStates := {}

Loop, 5 {
    CurrentID := A_Index + 5
    
    AHI.SubscribeKey(CurrentID, 347, true, Func("KeyEvent").Bind("F13", 0x7C))
    AHI.SubscribeKey(CurrentID, 57,  true, Func("KeyEvent").Bind("F14", 0x7D))
    AHI.SubscribeKey(CurrentID, 348, true, Func("KeyEvent").Bind("F15", 0x7E))
    AHI.SubscribeKey(CurrentID, 336, true, Func("KeyEvent").Bind("F16", 0x7F))
    AHI.SubscribeKey(CurrentID, 284, true, Func("KeyEvent").Bind("F17", 0x80))
    AHI.SubscribeKey(CurrentID, 2,   true, Func("KeyEvent").Bind("F18", 0x81))
    AHI.SubscribeKey(CurrentID, 7,   true, Func("KeyEvent").Bind("F19", 0x82))
    AHI.SubscribeKey(CurrentID, 12,  true, Func("KeyEvent").Bind("F20", 0x83))
    AHI.SubscribeKey(CurrentID, 327, true, Func("KeyEvent").Bind("F21", 0x84))
    AHI.SubscribeKey(CurrentID, 55,  true, Func("KeyEvent").Bind("F22", 0x85))
}

Return

KeyEvent(KeyName, VKCode, State) {
    global SendToEverything, KeyStates
    
    if (State == 1 && KeyStates[KeyName] == 1)
        return
    
    KeyStates[KeyName] := State
    
    if (SendToEverything) {
        Send, % "{" . KeyName . (State ? " Down}" : " Up}")
    } 
    else {
        Msg := State ? 0x0100 : 0x0101
        PostMessage, %Msg%, %VKCode%, 0, REAPERTrackListWindow1, ahk_class REAPERwnd
    }
}