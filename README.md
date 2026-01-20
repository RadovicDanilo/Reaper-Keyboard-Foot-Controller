# 🎸 Reaper-Keyboard-Foot-Controller

**Reaper-Keyboard-Foot-Controller** lets you use a **second keyboard** as a dedicated foot / macro controller for **REAPER** and **other DAWs**. It can send either **MIDI events** or **key presses** (F13-F22).

## 🧠 What is this?

At a high level: **AutoHotkey + AutoHotInterception (AHI)** intercepts keys **only from one physical keyboard**.

It operates in two modes (**MIDI Mode is default**):

1. **MIDI Mode:** Sends virtual MIDI CC messages (30–39) via **loopMIDI**. 
  - This mode will work with other DAWs and with standalone plugins.
2. **Keyboard Mode:** Remaps keys to `F13–F22` and injects them directly into REAPER using `PostMessage`. 
  - This mode is tailore to reaper, but it can be made to work with other programs too.

Because it talks directly to REAPER’s window or the MIDI bus, it **works even when REAPER is in the background**.

The setup is **very fast** with a **seamless transition** (less than 5ms delay).

---

## 🔌 Dependencies

* **AutoHotkey (v1)** -> must be installed
* **AutoHotInterception** -> already included in `Lib/`
* **loopMIDI** -> required to create the virtual MIDI port

Optional:

* **ReaPack** -> required to use Lua scripts
* **SWS** -> required to set the "Enforce Single Unmuted Track" script to run on **Reaper startup**

---

## ⌨ Hardware layout ️

![Keyboard example](images/kbd.jpg)

**Recommendations:**

* **10 keys total** 
* Keys should be **well spaced** so you can hit them blindly with your foot
* If the keys are too short glue **LEGO bricks** or similar plastic blocks on top to increase height and tactile feedback

---

## 📁 Repository structure

* **`ReaperControl.ahk`** Main script. Intercepts keys from the second keyboard. Handles MIDI CC 30–39 and Keyboard F13–F22 logic.
* **`Monitor.ahk`** Utility to detect **DeviceID** of each keyboard and see **ScanCodes** (like 347, 57, etc.) when you press them.
* **`Lib/`** AutoHotInterception libraries and DLLs (already included).
* **`Add marker if recording.lua`** *(optional)* Adds a marker when triggered, but only if REAPER is recording.
* **`Enforce Single Unmuted Track.lua`** *(optional)* Prevents more than one track from being unmuted at the same time.

---

## ⚙ LoopMIDI setup

After installing LoopMIDI create a port called: `LoopMIDI Port`

## ️⚙ Core script (`ReaperControl.ahk`)

### 🧩 What this actually does

* Subscribes to **keyboard ID(s)** (IDs 6–10, see the next section for the explanation)
* **MIDI Mode (Default):** Sends CC messages.
* **Keyboard Mode:** Maps 10 physical keys → `F13–F22`.
* **Mode Switch:** Physical key 9 (ScanCode 10) toggles between modes. You can press this one with a pen if you dont want to include a physical key cap.
* Sends events straight into REAPER or the MIDI port with no focus needed.

---

## 🔍 Finding the correct keyboard and keys

Run **`Monitor.ahk`**. You will see:

* Which **keyboard device ID** is producing input
* Which **ScanCode** is pressed (Mapping uses these codes, e.g., 347, 57)

Important details:

* The **new keyboard will always have the highest DeviceID**
* **DeviceID is NOT constant**

  * It increments every time you plug/unplug a device
  * It resets only after a full shutdown
  * The **maximum ID is 10**

Because of that, this script subscribes to **everything above ID 5**, because in my case I have 5 keyboarad devices that are alredy plugged into my PC:

This guarantees the second keyboard is always detected, even if I unplug and replug it. This will never happen more that 3 times per day so the ID limit of 10 is inconsequential.

---

## 🚀 Set the AHK script to run on startup

This is easily achieved by creating a shortcut to the script and placing it in the Windows startup folder (`shell:startup`).

---

## ️🎵 REAPER setup

For **Keyboard Mode (`F13–F22`)**, create actions to:

1. **Mute all tracks**
2. **Unmute track N**
3. **Run “Add marker if recording.lua”**

**Note:** all tracks that you wish to use will need to be **armed for recording**

---

For **MIDI Mode (CC 30–39)**:

Examples:

* Map CCs to pedal bypasses in AmpliTube.
* Map to REAPER actions like the **Tuner**.

---

## 📜 Optional Lua scripts (only for keyboard mode)

### `Add marker if recording.lua`

* Adds a marker only if REAPER is currently recording.
* Requires **ReaPack**.

### `Enforce Single Unmuted Track.lua`

* Safety precaution to ensure only one track is unmuted.
* Requires **ReaPack**.
* Use **SWS** to auto-start this when REAPER opens.

---

## 🎼 Seting up a tuner (recommended) 

I recomend that you have one track that will be used a **tuner**

### keyboard mode

* I recommend that you set it to be the **last track (track 10)**
* Add a **tuner plugin**, you can used the built-in **ReaTune**
* Set the volume to **-inf**, it is not enough to just mute it
* Dock the FX windwos to the reaper **Docker** to make it **always visible**

### MIDI mode

* Set it to be the **first track (track 1)**
* Create a **Custom Action** using `Action: Skip next action if CC parameter <= 0/mid` followed by `Track: toggle solo for track 01`.
* everything else is the same as for the keyboard version, set volume to -inf and dock to the reaper docker etc.