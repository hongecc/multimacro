; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
mode := ""
rounds := 000
loops := 000

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
    Gui, Status: Add, Text, vLoops, Times Looped: %loops%
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
        Click 718, 810
        Sleep, 500
        condition2 := True
    }

    if (!condition3 && condition2) {
        GuiControl, Status:, StatusText, Status: ready
        PixelSearch, foundX, foundY, 838, 1007, 1046, 1066, 0x3A2F10, 0, Fast RGB
        if (ErrorLevel = 0) {
            GuiControl, Status:, StatusText, Status: waitingforresult
            Sleep, 1500
            Click 939, 1040
            Sleep, 100
            condition3 := True
            condition4 := False
        }
    }
    if (!condition4) {
        PixelGetColor, color, 928, 227, RGB
        if (color = 0xDEDDDE) {
            GuiControl, Status:, StatusText, Status: untilnext
            Sleep, 3000
            Loop {
                Click 872, 704
                PixelGetColor, color, 943, 874, RGB
                if (color = 0xCDCCCD) {
                    GuiControl, Status:, StatusText, Status: untilnext
                    Click 943, 874
                    Sleep, 100
                    rounds++
                    GuiControl, Status:, Rounds, Rounds: %rounds%
                    condition3 := False
                    condition4 := True
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
        PixelGetColor, color, 938, 1030, RGB
        if (color = 0xE2DFE2) {
            GuiControl, Status:, StatusText, Status: Restarting
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            Mousemove, 941, 1032
            Click
            Sleep 3000
            com1 := True
            }
        else {
            Sleep 3000
            Click
            }
        }
    }
    if (!com2) {
        PixelGetColor, color, 939, 500, RGB
        if (color = 0x181C29) {
            Sleep 500
            Mousemove, 939, 500
            Click
            Sleep 1500
            com3 := False
            com2 := True
    if (!com3) {
        PixelGetColor, color, 931, 925, RGB
        if (color = 0x040404) {
            Sleep 500
            Mousemove, 931, 925
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
