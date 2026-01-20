#Persistent
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk

; ScanCode: ["KeyName", VKCode, CC_Number]
Mappings := { 347: ["F13", 0x7C, 102], 57:  ["F14", 0x7D, 103], 348: ["F15", 0x7E, 104]
            , 336: ["F16", 0x7F, 105], 284: ["F17", 0x80, 106], 2:   ["F18", 0x81, 107]
            , 7:   ["F19", 0x82, 108], 12:  ["F20", 0x83, 109], 327: ["F21", 0x84, 110]
            , 55:  ["F22", 0x85, 111] }

global hMidiOut := 0
global IsMidiMode := true
global KeyStates := {}

; --- INITIALIZATION ---
TargetPortName := "LoopMIDI Port"
MidiID := GetMidiOutId(TargetPortName)

; Open Port - Using Ptr* for handles is essential for 64-bit systems
if (MidiID != -1) {
    DllCall("winmm\midiOutOpen", "Ptr*", hMidiOut, "UInt", MidiID, "Ptr", 0, "Ptr", 0, "UInt", 0)
}

AHI := new AutoHotInterception()
UpdateIcon()

Loop, 5 {
    DeviceID := A_Index + 5
    AHI.SubscribeKey(DeviceID, 10, true, Func("ToggleMode"))
    
    for ScanCode, Info in Mappings
        AHI.SubscribeKey(DeviceID, ScanCode, true, Func("KeyEvent").Bind(Info[1], Info[2], Info[3]))
}
Return

ToggleMode(State) {
    global IsMidiMode
    if (State == 0) 
        return
    IsMidiMode := !IsMidiMode
    UpdateIcon()
}

UpdateIcon() {
    global IsMidiMode
    Menu, Tray, Icon, shell32.dll, % (IsMidiMode ? 132 : 138)
}

KeyEvent(KeyName, VK, CC, State) {
    global hMidiOut, IsMidiMode, KeyStates
    
    if (IsMidiMode && hMidiOut) {
        ; 0xB0 = Control Change, Channel 1
        ; msg = StatusByte | (Data1 << 8) | (Data2 << 16)
        Value := State ? 127 : 0
        msg := 0xB0 | (CC << 8) | (Value << 16)
        
        DllCall("winmm\midiOutShortMsg", "Ptr", hMidiOut, "UInt", msg)
        Return
    }

    if (State == 1 && KeyStates[KeyName])
        Return
    KeyStates[KeyName] := State
    PostMessage, (State ? 0x0100 : 0x0101), VK, 0, REAPERTrackListWindow1, ahk_class REAPERwnd
}

GetMidiOutId(PortName) {
    NumDevs := DllCall("winmm\midiOutGetNumDevs")
    Loop, %NumDevs% {
        DeviceID := A_Index - 1
        VarSetCapacity(Caps, 84, 0)
        if (DllCall("winmm\midiOutGetDevCaps", "UInt", DeviceID, "Ptr", &Caps, "UInt", 84) == 0) {
            ; LoopMIDI names are UTF-16
            if InStr(StrGet(&Caps + 8, 32, "UTF-16"), PortName)
                Return DeviceID
        }
    }
    Return -1
}

OnExit:
    if (hMidiOut)
        DllCall("winmm\midiOutClose", "Ptr", hMidiOut)
ExitApp