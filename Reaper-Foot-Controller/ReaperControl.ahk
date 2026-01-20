#Persistent
#SingleInstance Force
#Include Lib\AutoHotInterception.ahk

; ScanCode: ["KeyName", VirtualKeyCode, CC_Number]
Mappings := { 347: ["F13", 0x7C, 30], 57:  ["F14", 0x7D, 31], 348: ["F15", 0x7E, 32]
            , 336: ["F16", 0x7F, 33], 284: ["F17", 0x80, 34], 2:   ["F18", 0x81, 35]
            , 7:   ["F19", 0x82, 36], 12:  ["F20", 0x83, 37], 327: ["F21", 0x84, 38]
            , 55:  ["F22", 0x85, 39] }

TargetPortName := "LoopMIDI Port"
MidiDeviceID := GetMidiOutId(TargetPortName)
DllCall("winmm\midiOutOpen", "UInt*", hMidiOut, "UInt", MidiDeviceID, "UInt", 0, "UInt", 0, "UInt", 0)

AHI := new AutoHotInterception()

global SendToEverything := false, IsMidiMode := true, KeyStates := {}
hMidiOut := 0

UpdateIcon()

Loop, 5 {
    ID := A_Index + 5
    AHI.SubscribeKey(ID, 10, true, Func("ToggleMode"))
    for ScanCode, Info in Mappings
        AHI.SubscribeKey(ID, ScanCode, true, Func("KeyEvent").Bind(Info[1], Info[2], Info[3]))
}
Return

ToggleMode(State) {
    global IsMidiMode
    if (State == 1) 
        return
    IsMidiMode := !IsMidiMode
    UpdateIcon()
}

UpdateIcon() {
    global IsMidiMode
    Menu, Tray, Icon, shell32.dll, % (IsMidiMode ? 132 : 138)
}

KeyEvent(KeyName, VKCode, CC, State) {
    global SendToEverything, KeyStates, IsMidiMode, hMidiOut
    
    if (IsMidiMode) {
        DllCall("winmm\midiOutShortMsg", "UInt", hMidiOut, "UInt", 0xB0 | (CC << 8) | ((State ? 127 : 0) << 16))
        Return
    }

    if (State == 1 && KeyStates[KeyName])
        Return
    KeyStates[KeyName] := State

    if (SendToEverything) {
        Send, % "{" KeyName (State ? " Down}" : " Up}")
    } else {
        PostMessage, (State ? 0x0100 : 0x0101), VKCode, 0, REAPERTrackListWindow1, ahk_class REAPERwnd
    }
}

GetMidiOutId(PortName) {
    NumDevices := DllCall("winmm\midiOutGetNumDevs")
    Loop, %NumDevices% {
        DeviceID := A_Index - 1
        VarSetCapacity(Caps, 84, 0)
        if (DllCall("winmm\midiOutGetDevCaps", "UInt", DeviceID, "Ptr", &Caps, "UInt", 84) == 0) {
            if InStr(StrGet(&Caps + 8, 32, "UTF-16"), PortName)
                Return DeviceID
        }
    }
    Return -1
}

OnExit:
    if (hMidiOut)
        DllCall("winmm\midiOutClose", "UInt", hMidiOut)
ExitApp