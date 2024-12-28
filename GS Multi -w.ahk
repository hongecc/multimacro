; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
mode := ""
rounds := 000

; Create the mode selection GUI
Modes() {
    global
    Gui, Mode: +AlwaysOnTop +Owner
    Gui, Mode: Add, Text,, Select Mode:
    Gui, Mode: Add, Button, gNonHostMode w200 h50, Non-Host
    Gui, Mode: Add, Button, gAutoCompendium w200 h50, Auto Compendium
    Gui, Mode: Show, x10 y10, Select Mode 
}

Modes()
return


; Non-Host mode action
NonHostMode:
mode := "Non-Host"
Gui, Mode: Destroy
MsgBox, Make sure you have already set your unit AI, and joined a lobby before starting.
ShowMainGUI()
return

AutoCompendium:
mode := "Auto Compendium"
Gui, Mode: Destroy
MsgBox, Make sure you have a "preset team", started a loop before starting.
ShowMainGUI()
return
; Show the main control GUI
ShowMainGUI() {
    global
    Gui, Main: +AlwaysOnTop +Owner
    Gui, Main: Add, Tab2, w400 h300, Control|Shortcuts
    Gui, Main: Tab, Control
    Gui, Main: Add, Button, gStartScript w200 h50, Start(F1)
    Gui, Main: Add, Button, gPauseScript w200 h50, Pause(F2)
    Gui, Main: Add, Button, gStopScript w200 h50, Stop(F3)
    Gui, Main: Tab, Shortcuts
    Gui, Main: Add, Text,, F1 - Start
    Gui, Main: Add, Text,, F2 - Pause
    Gui, Main: Add, Text,, F3 - Stop
    Gui, Main: Tab
    Gui, Main: Show, x10 y10, GS Multi (Non-Host) Control

    ; Create the status GUI
    Gui, Status: +AlwaysOnTop +Owner
    Gui, Status: Add, Text, vStatusText, Status: Stopped
    Gui, Status: Add, Text, vRounds, Rounds: %rounds%
    Gui, Status: Show, x10 y320, Script Status

    ; Set hotkeys
    Hotkey, F1, StartScript
    Hotkey, F2, PauseScript
    Hotkey, F3, StopScript
}

; Start button action
StartScript:
isRunning := true
isPaused := false
foodClicked := false
GuiControl, Status:, StatusText, Status: Looking for buttons
SetTimer, CheckReadyButton, 100
return

; Pause button action
PauseScript:
isPaused := !isPaused
if (isPaused)
    GuiControl, Status:, StatusText, Status: Paused
else
    GuiControl, Status:, StatusText, Status: Looking for buttons
Gui, Main: Show
Gui, Status: Show
return

; Stop button action
StopScript:
isRunning := false
SetTimer, CheckReadyButton, Off
GuiControl, Status:, StatusText, Status: Stopped
MsgBox, 0x40000, Script Stopped, Your script has been stopped either manually, disconnected or you weren't in a farm party.
Gui, Main: Show
Gui, Status: Show
ExitApp
return

; Main loop
CheckReadyButton:
if (isRunning and !isPaused)
{
    if (mode = "Non-Host") {
        NonHostModeFunction()
    }
    else if (mode = "Auto Compendium") {
        AutoCompendium()
    }
}
return

; Non-Host mode function
condition1 := False
condition2 := False
condition3 := False
condition4 := True

NonHostModeFunction() { 
    global
    ; Check if the pixel at (827, 658) is color 
    if (!condition1) {
        PixelGetColor, color, 827, 658, RGB
        if (color = 0xEDEDED) {
            GuiControl, Status:, StatusText, Status: joinparty
            Click 827, 658
            Sleep, 1000 ; Wait for 1 second to simulate the click delay
            condition1 := True
        }
    }   
    if (!condition2) {
        GuiControl, Status:, StatusText, Status: food
        Click 718, 810 ; food
        Sleep, 500
        condition2 := True
    }

    if (!condition3 && condition2) {
        GuiControl, Status:, StatusText, Status: ready
        PixelGetColor, color, 867, 987, RGB ; Ready Button
        if (color = FF581F) {
            GuiControl, Status:, StatusText, Status: waitingforresult
            Sleep, 2000
            Click 935, 991 
            Sleep, 100
            condition3 := True
            condition4 := False
            }
        }
    if (!condition4) {
        PixelGetColor, color, 947, 218, RGB ; Results
        if (color = 0xD7D7D7) { ; Results Color
            GuiControl, Status:, StatusText, Status: untilnext
            Sleep, 3000
            Loop {
                Click 943, 657 ; Inventory Full
                PixelGetColor, color, 939, 834, RGB ; Next Button
                if (color = 0x232523) {
                    GuiControl, Status:, StatusText, Status: clicknext
                    Sleep, 800
                    Click 901, 833 ; Next Button
                    Sleep, 100
                    condition3 := False
                    condition4 := True
                    rounds++
                    GuiControl, Status:, rounds, Rounds: %rounds%
                    break
                }
            }
        }
    }
}


com1 := False
com2 := True
com3 := True

AutoCompendium() {
    global
    {
    if (!com1) {
        PixelGetColor, color, 940, 988, RGB ; Ok Button
        if (color = 0x878787) { ; Ok Button Colour
            GuiControl, Status:, StatusText, Status: Restarting
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            Sleep, 1500
            Click 939, 562
            Sleep, 500
            Click 939, 562
            Sleep, 1500
            Mousemove, 940, 988 ; Ok Button
            Click
            com1 := True
            com2 := False
            }
        else {
            Sleep, 3000
            Click
            }
        }
    }
    if (!com2) {
        PixelGetColor, color, 940, 487, RGB ; Cross Battle
        if (color = 0x342152) {
            Sleep, 500
            Mousemove, 940, 487 ; Cross Battle
            Click
            Sleep 1500
            com3 := False
            com2 := True
            }
    }
    if (!com3) {
        PixelGetColor, color, 938, 883, RGB ; Battle
        if (color = 0x000000) {
            Sleep 500
            Mousemove, 938, 883 ; Battle
            Click
            Sleep 750
            Click
            com1 := False
            com3 := True
        
        }
    }
}


Exit the script when the GUI is closed
GuiClose:
ExitApp


