# Logitech MX Keys & Master - Auto Switch (Windows)

A lightweight, invisible PowerShell solution to **automatically switch your MX Master mouse** when you switch your **MX Keys keyboard** to another computer.

## 🚀 The Problem
Native Logitech "Easy-Switch" keys (1, 2, 3) only switch the keyboard. To switch the mouse, you have to lift it and press the button underneath, or use Logitech Flow (which requires network and software running).

## ✅ The Solution
This script uses "Hardware Polling". It detects when the keyboard disconnects from PC 1 (because you pressed "2") and immediately sends a USB command to the mouse to force it to switch to PC 2.

**Benefits:**
- Works even if the other PC is locked or sleeping.
- No background software installation required (uses native PowerShell).
- Instant switching.
- Works with **MX Keys S**, **MX Master 3S**, and likely older Bolt/Unifying devices.

## 📦 Prerequisites
- 2 Windows PCs.
- **hidapitester.exe** (Command line tool to talk to USB devices).
- This repository's scripts.

## 🛠️ Installation Guide

### 1. Download & Prepare
1. Create a folder `C:\LogiSwitch` on **BOTH** computers.
2. Download `hidapitester_windows_x64.zip` from [todbot/hidapitester](https://github.com/todbot/hidapitester/releases) and extract `hidapitester.exe` into that folder.
3. Download the scripts from this repository (`0_Get_IDs.ps1`, `PC1_SwitchTo2.ps1`, `PC2_SwitchTo1.ps1`) and place them in the folder.

### 2. Get your Hardware IDs
On one of your computers:
1. Right-click `0_Get_IDs.ps1` and select **Run with PowerShell**.
2. Note the IDs for your Keyboard (e.g., `046D:B378`) and Mouse (e.g., `046D:B034`).

### 3. Configure the Scripts

#### On PC 1 (The PC linked to Key 1)
1. Open `PC1_SwitchTo2.ps1` with Notepad.
2. Replace `$KeyboardID` and `$MouseID` with your own codes.
3. Ensure `$TargetForMouse` is set to the correct channel for PC 2 (usually `0x01`).
4. Save.

#### On PC 2 (The PC linked to Key 2)
1. Open `PC2_SwitchTo1.ps1` with Notepad.
2. Replace `$KeyboardID` and `$MouseID` with your own codes.
3. Ensure `$TargetForMouse` is set to the correct channel for PC 1 (usually `0x00`).
4. Save.

### 4. Auto-Start (Set and Forget)
To make it run silently in the background at startup:
1. Press `Win + R`, type `shell:startup`, and press Enter.
2. Create a shortcut in this folder.
3. Set the shortcut target to:
   `powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\LogiSwitch\PC1_SwitchTo2.ps1"`
   *(Change the filename accordingly for PC 2).*

## ⚠️ Disclaimer
This script relies on `hidapitester` to send raw HID commands. Use at your own risk. This is not an official Logitech product.
