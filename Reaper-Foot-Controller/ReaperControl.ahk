#Persistent
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk

; --- CONFIGURATION ---
DeviceID := 6
SendToEverything := false 
AHI := new AutoHotInterception()

; Initialize the memory object to track key states (prevents auto-repeat)
global KeyStates := {}

AHI.SubscribeKey(DeviceID, 347, true, Func("KeyEvent").Bind("F13", 0x7C))
AHI.SubscribeKey(DeviceID, 57,  true, Func("KeyEvent").Bind("F14", 0x7D))
AHI.SubscribeKey(DeviceID, 348, true, Func("KeyEvent").Bind("F15", 0x7E))
AHI.SubscribeKey(DeviceID, 336, true, Func("KeyEvent").Bind("F16", 0x7F))
AHI.SubscribeKey(DeviceID, 284, true, Func("KeyEvent").Bind("F17", 0x80))
AHI.SubscribeKey(DeviceID, 2,   true, Func("KeyEvent").Bind("F18", 0x81))
AHI.SubscribeKey(DeviceID, 7,   true, Func("KeyEvent").Bind("F19", 0x82))
AHI.SubscribeKey(DeviceID, 12,  true, Func("KeyEvent").Bind("F20", 0x83))
AHI.SubscribeKey(DeviceID, 327, true, Func("KeyEvent").Bind("F21", 0x84))
AHI.SubscribeKey(DeviceID, 55,  true, Func("KeyEvent").Bind("F22", 0x85))

Return

KeyEvent(KeyName, VKCode, State) {
    global SendToEverything, KeyStates
    
    ; --- ANTI-REPEAT LOGIC ---
    ; If the key is already down and we get another 'down' signal, ignore it
    if (State == 1 && KeyStates[KeyName] == 1) {
        return
    }
    
    ; Update the memory with current state (1 for down, 0 for up)
    KeyStates[KeyName] := State
    
    if (SendToEverything) {
        if (State) 
            Send, {%KeyName% Down}
        else 
            Send, {%KeyName% Up}
    } 
    else {
        ; 0x0100 is WM_KEYDOWN, 0x0101 is WM_KEYUP
        Msg := State ? 0x0100 : 0x0101
        
        ; Target REAPER directly in the background
        PostMessage, %Msg%, %VKCode%, 0, REAPERTrackListWindow1, ahk_class REAPERwnd
    }
}