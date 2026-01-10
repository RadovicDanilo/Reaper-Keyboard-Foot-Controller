# Reaper-Keyboard-Foot-Controller 🎸

**Reaper-Keyboard-Foot-Controller** lets you use a **second keyboard** as a dedicated foot / macro controller for **REAPER**.  

## What is this?

At a high level: **AutoHotkey + AutoHotInterception (AHI)** intercepts keys **only from one physical keyboard**, remaps them to `F13–F22`, and injects them into REAPER using `PostMessage`. 

Because it talks directly to REAPER’s window, it **works even when REAPER is in the background**. 

Reaper than runs **custom user actions** to switch tracks loaded with different guitar tones.

The setup is **very fast** with a **seamless transition** with an imperceptible delay (less than 5ms on a solid PC).

No MIDI. No focus issues. No foreground requirement. No conflict with your regular keyboard. Almost no delay.

---

## Dependencies

- **AutoHotkey (v1)** -> must be installed
- **AutoHotInterception** -> already included in `Lib/`
- **REAPER**
- **ReaPack** -> required *if* you want to use Lua scripts
- **SWS** -> recommended (for auto-starting reaper scripts)

---

## Hardware layout

![Keyboard example](images/kbd.jpg)

**Recommendations:**
- **10 keys total** (matches `F13–F22`)
- Keys should be **well spaced** so you can hit them blindly with your foot
- If the keys are too short glue **LEGO bricks** or similar plastic blocks on top to increase height and tactile feedback  

---

## Repository structure

- **`ReaperControl.ahk`**  
  Main script. Intercepts keys from the second keyboard and sends them to REAPER.

- **`Monitor.ahk`**  
  Utility to:
  - detect **DeviceID** of each keyboard
  - see **key IDs** when you press them

- **`Lib/`**  
  AutoHotInterception libraries and DLLs (already included).

- **`Add marker if recording.lua`** *(optional)*  
  Adds a marker when triggered, but only if REAPER is recording.

- **`Enforce Single Unmuted Track.lua`** *(optional)*  
  Prevents more than one track from being unmuted at the same time.

---

## Core script (`ReaperControl.ahk`)

This is the main part of the setup.

### What this actually does

* Subscribes to **keyboard ID(s)**
* Maps 10 physical keys → `F13–F22`
* Sends key **down/up** events straight into REAPER’s track list window
* No focus needed

---

## Finding the correct keyboard and keys

Run **`Monitor.ahk`**.

You will see:

* Which **keyboard device ID** is producing input
* Which **key ID** is pressed

Important details:

* The **new keyboard will always have the highest DeviceID**
* **DeviceID is NOT constant**

  * It increments every time you plug/unplug a device
  * It resets only after a full shutdown
* The **maximum ID is 10**

Because of that, this script subscribes to **everything above ID 5**, because in my case I have 5 keyboarad devices that are alredy plugged into my PC:

This guarantees the second keyboard is always detected, even if I unplug and replug it. This will never happen more that 3 times per day so the ID limit of 10 is inconsequential.

## Set the AHK script to run on startup

This script, if setup correctly, will have no impact on other keyboards. Since it has no effects on the CPU it is best to set it up to run on PC startup. 

This is easily achived by creating a shortcut to the script and placing it in the windwos startup folder.

---

## REAPER setup

For **each key (`F13–F22`)**, create a REAPER action that does the following:

1. **Mute all tracks**
2. **Unmute track N**
3. **Run “Add marker if recording.lua”**

That logic lives in REAPER, not in AHK.
AHK only delivers clean, isolated key presses.

**Note:** all tracks that you wish to use will need to be **armed for recording**

---

## Optional Lua scripts

### `Add marker if recording.lua`

* Adds a marker only if REAPER is currently recording
* Safe to trigger at all times
* Requires **ReaPack**

### `Enforce Single Unmuted Track.lua`

* Continuously enforces that only **one track** can be unmuted
* This is **not neccessary** it is only a safety precaution because all tracksa will be armed for recording
* Runs in the background
* Can be easily terminated when not needed. 
* Use **SWS** to auto-start it on REAPER launch

## Seting up a tuner (recommended)

I recomend that you have one track that will be used a **tuner**

* I recommend that you set it to be the **last track (track 10)**
* Add a **tuner plugin**, you can used the built-in *ReaTune**
* Set the volume to **-inf**, it is not enough to just mute it
* Dock the FX windwos to the reaper **Docker** to make it **always visible**
