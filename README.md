# Reaper-Keyboard-Foot-Controller 🎸

️This project allows you to use a **second keyboard** as a dedicated controller for REAPER. It uses **AutoHotInterception (AHI)** to intercept keys from a specific device and **PostMessage** to "force" those commands into REAPER, even when it is running in the background.

## 📺 Video OverviewFor a simple explanation of how the setup works, watch the tutorial here (note: AHK is not included in this version):

[Reaper Keyboard Foot Controller - YouTube](https://www.youtube.com/watch?v=EQ_CVvrscqc)

## 📂 Repository Structure* 

* **`ReaperControl.ahk`**: The main AutoHotkey script. It identifies your second keyboard and remaps keys to `F13`–`F22`, sending them directly to the REAPER track list window.

* **`Monitor.ahk`**: Use this tool to find the `DeviceID` of your specific keyboard and to identify keyIDs.

* **`Lib/`**: Contains the necessary `AutoHotInterception` libraries and DLLs.

* `Add marker if recording.lua`: (optional) Adds a marker when a key is pressed if recording

* `Enforce Single Unmuted Track.lua`: (optional) Blocks multiple tracks from being unmuted at once, you should run this on startup with SWS
