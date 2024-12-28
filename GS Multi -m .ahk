; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
mode := ""
rounds := 000
loops := 000
MaxLoops = 000

; Create the mode selection GUI
Modes() {
    global
    Gui, Mode: +AlwaysOnTop +Owner
    Gui, Mode: Add, Text,, Select Mode:
    Gui, Mode: Add, Button, gNonHostMode w200 h50, Non-Host
    Gui, Mode: Add, Button, gAutoCompendium w200 h50, Auto Compendium
    Gui, Mode: Add, Button, gAutoCrest w200 h50, Auto Crest
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
MsgBox, Make sure you have already started the l00p at raid boss practice before starting.
ShowMainGUI()
return
AutoCrest:
mode := "Auto Crest"
MsgBox, Make sure you have already started the loop crest before starting.
MaxLoop()
return

MaxLoop() {
    global
    Gui, MaxLoops: +AlwaysOnTop +Owner
    Gui, MaxLoops: Add, Text,, Select the amount of maximum loops you have:
    Gui, MaxLoops: Add, Button, g50Loop w200 h50, 50
    Gui, MaxLoops: Add, Button, g100Loop w200 h50, 100
    Gui, MaxLoops: Show, x10 y10, Select Loops
}
; Hosting mode action
50Loop:
MaxLoops = 50
Gui, Mode: Destroy
Gui, MaxLoops: Destroy
ShowMainGUI()
Return
100Loop:
MaxLoops = 100
Gui, Mode: Destroy
Gui, MaxLoops: Destroy
ShowMainGUI()
Return

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
    else if (mode = "Auto Crest") {
        AutoCrest()
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
        PixelSearch, foundX, foundY, 837, 1005, 1050, 1062, 0x8B3611, 0, Fast RGB
        if (ErrorLevel = 0) {
            GuiControl, Status:, StatusText, Status: waitingforresult
            Sleep, 1500
            Click 939, 1036
            Sleep, 100
            condition3 := True
            condition4 := False
        }
    }
    if (!condition4) {
        PixelGetColor, color, 934,221, RGB
        if (color = 0x000408) {
            GuiControl, Status:, StatusText, Status: untilnext
            Sleep, 3000
            Loop {
                Click 940, 701
                PixelGetColor, color, 935, 864, RGB
                if (color = 0xBC5C14) {
                    GuiControl, Status:, StatusText, Status: clicknext
                    Click 935, 864
                    Sleep, 100
                    condition3 := False
                    condition4 := True
                    break
                }
            }
        }
    }
}

con := False
con1 := False
con2 := True

AutoCompendium() {
    global
    {
    PixelGetColor, color, 935, 477, RGB ; Start Message
    if (color = 0x002341) { 
        rounds++
        GuiControl, Status:, Rounds, Rounds: %rounds%
        Sleep 5000
        }

    if (!con) {
        Mousemove 937, 880
        Sleep 2500
        Click
        Sleep 1000
        Click
        con := True
    }

    if (!con1) {
        PixelGetColor, color, 966, 980, RGB
        if (color = 0xFF8924) {
            GuiControl, Status:, StatusText, Status: Restarting
            Sleep 750
            Mousemove, 996, 980
            Click
            Sleep 3000
            con1 := True
            }
        else {
            Click
            }
        }
    }
    if (!con2) {
        PixelGetColor, color, 971, 447, RGB
        if (color = 0x085973) {
            Sleep 750
            Mousemove, 971, 447
            Sleep 750
            Click
            Mousemove, 937, 880
            Sleep 750
            Click
            Sleep 750
            Click
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            con1 := False
            con2 := True
        }
    }
}

counter = 00
AutoCrest() {
    global
    {  
        if (!con) {
            PixelGetColor, color, 947, 921, RGB
            if (color = 0x8A8C98) {
                Mousemove 947, 921 ; Battle
                Sleep 2500
                Click
                Sleep 1000
                Click
                con := True 
            }
        }
        if (!con1) {
            Loop {
                if (counter+1 = MaxLoops) {
                    PixelGetColor, color, 1134, 1021, RGB ; End Battle
                    if (color = 0x2A96FF) {
                        Sleep, 750
                        Mousemove, 1134, 1021 ; End Battle 
                        Click
                        Sleep, 1500
                        Mousemove, 939, 809 ; Crest Reward
                        Click
                        Sleep, 1000
                        Click
                        Sleep, 1000
                        Click
                        Mousemove, 943, 1038 ; Ok
                        Sleep, 1000
                        Click
                        GuiControl, Status:, StatusText, Status: Restarting
                        con2 := False
                        con1 := True
                        break
                    }
                }
                else if (counter < MaxLoops) {
                    PixelGetColor, color, 929, 450, RGB ; Start Message
                    if (color = 0x282828) { 
                        counter++
                        rounds++
                        GuiControl, Status:, Rounds, Rounds: %rounds%
                        Sleep 5000
                        }
                else {
                    PixelGetColor, color, 1108, 635 ; Cancel
                    if (color = 0x2D312D) {
                        Mousemove, 1108, 635 ; Cancel
                        Click
                        Sleep, 1000
                        Mousemove, 937, 672 ; Restart
                        Click
                        }
                    Else {
                        mousemove 939, 809 ; Crest Reward
                        sleep 750
                        click
                }
                    }
                }
            }
        }
    }
    if (!con2) {
        PixelGetColor, color, 934, 615, RGB ; Select Stage
        if (color = 0x181418) {
            Mousemove, 934, 615 ; Select Stage
            Click
            Sleep 1500
            Mousemove, 802, 482 ; Single player
            Click
            Sleep 1500
            Mousemove, 947, 921 ; Battle
            Click
            Sleep 750
            Click
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            counter = 0
            con1 := False
            con2 := True
        }
    }
}

Exit the script when the GUI is closed
GuiClose:
ExitApp
