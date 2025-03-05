    ; Initialize variables
    isRunning := false
    isPaused := false
    foodClicked := false
    mode := ""
    rounds := 0000
    loops := 000
    MaxLoops := 000
    fail := 000

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
    MsgBox, Make sure you have a "preset team", started a loop before starting.
    ShowMainGUI()
    return

    ; Auto Crest mode action
    AutoCrest:
    mode := "Auto Crest"
    MsgBox, Make sure you have already started the loop crest before starting.
    MaxLoop()
    return


    MaxLoop() {
        global
        Gui, MaxLoops: +AlwaysOnTop +Owner
        Gui, MaxLoops: Add, Text,, Select the amount of maximum loops you have:
        Gui, MaxLoops: Add, Button, gtest w200 h50, Test (three loops)
        Gui, MaxLoops: Add, Button, g100Loop w200 h50, 100
        Gui, MaxLoops: Show, x10 y10, Select Loops
    }


    ; Hosting mode action
    test:
    MaxLoops = 3
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
        Gui, Status: Add, Text, vFailed, Times Failed: %fail%
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
    condition4 := True

    NonHostModeFunction() { 
        global
        if (!condition1) {
            PixelGetColor, color, 1111, 921, RGB
            if (color = 0x340F00) {
                GuiControl, Status:, StatusText, Status: joinparty
                Click 1111, 921
                Sleep, 1000 ; Wait for 1 second to simulate the click delay
                condition1 := True
            }
        }   
        if (!condition2) {
            GuiControl, Status:, StatusText, Status: food
            Click 995, 1131 ; food
            Sleep, 500
            condition2 := True
        }

        if (condition3) {
            GuiControl, Status:, StatusText, Status: ready
            PixelGetColor, color, 1270, 1367, RGB ; Ready Button
            if (color = 0xEF5518) {
            GuiControl, Status:, StatusText, Status: waitingforresult
            Sleep, 2000
            Click 1270, 1367
            Sleep, 100
            condition4 := False
        }

        if (!condition4) {
            PixelGetColor, color, 1280, 292, RGB ; Results
            if (color = 0xADAAAD) { ; Results Color
                GuiControl, Status:, StatusText, Status: untilnext
                Sleep, 3000
                Loop {
                    Click 1280, 949 ; Inventory Full
                    PixelGetColor, color, 1268, 1159, RGB ; Next Button
                    if (color = 0x4D1900) {
                        GuiControl, Status:, StatusText, Status: clicknext
                        Sleep, 800
                        Click 1268, 1159 ; Next Button
                        Sleep, 100
                        condition4 := True
                        rounds++
                        GuiControl, Status:, rounds, Rounds: %rounds%
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
        PixelGetColor, color, 885, 493, RGB ; reSult
        if (color = 0xE9FBFF) { 
            rounds++
            GuiControl, Status:, Rounds, Rounds: %rounds%
            Sleep 5000
            }

        if (!con) {
            Mousemove 904, 913
            Sleep 2500
            Click
            Sleep 1000
            Click
            con := True
        }

        if (!con1) {
            PixelGetColor, color, 945, 1032, RGB
            if (color = 0x8B8D8B) {
                GuiControl, Status:, StatusText, Status: Restarting
                Sleep 5000
                Mousemove, 945, 1032
                Click
                Sleep 3000
                con1 := True
                con2 := False
                }
            else {
                Mousemove, 943, 810
                Click
                }
            }
        }
        if (!con2) {
            PixelGetColor, color, 901, 464, RGB
            if (color = 0x109FAF) {
                Sleep 750
                Mousemove, 901, 464
                Sleep 750
                Click
                Sleep 3500
                Mousemove, 904, 913
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

    con := False
    con1 := False
    con2 := True

    counter = 000
    AutoCrest() {
        global
        {  
            if (!con) {
                Mousemove 895, 919
                Sleep 2500
                Click
                Sleep 2500
                Click
                con := True 
            }
            if (!con1) {
                Loop {
                    if (counter+1 = MaxLoops) {
                        PixelGetColor, color, 1073, 635 ; Cancel
                        if (color = 0xF4F3F4) {
                            Mousemove, 1073, 635 ; Cancel
                            Click
                            Sleep, 1000
                            Mousemove, 921, 675 ; Restart
                            Click
                            fail++
                            counter--
                            rounds--
                            GuiControl, Status:, Failed, Times Failed: %fail%
                            }
                        else {
                            mousemove 931, 806 ; Crest Reward
                            sleep 750
                            click
                        }
                        PixelGetColor, color, 1135, 1031, RGB ; End Battle
                        if (color = 0x1B73FF) {
                            Sleep, 750
                            Mousemove, 1135, 1031 ; End Battle 
                            Click   
                            Sleep, 1500
                            Mousemove, 931, 806 ; Crest Reward
                            Click
                            Sleep, 1000
                            Click
                            Sleep, 1000
                            Click
                            Mousemove, 933, 1027 ; Ok
                            Sleep, 1000
                            Click
                            GuiControl, Status:, StatusText, Status: Restarting
                            con2 := False
                            con1 := True
                            break
                        }
                    }
                    else if (counter < MaxLoops) {
                        PixelGetColor, color, 913, 488, RGB ; Start
                        if (color = 0x023D50) { 
                            counter++
                            rounds++
                            GuiControl, Status:, Rounds, Rounds: %rounds%
                            Sleep 4500
                            }
                    else {
                        PixelGetColor, color, 1073, 635 ; Cancel
                        if (color = 0xF4F3F4) {
                            Mousemove, 1073, 635 ; Cancel
                            Click
                            Sleep, 1000
                            Mousemove, 921, 675 ; Restart
                            Click
                            fail++
                            counter--
                            rounds--
                            GuiControl, Status:, Failed, Times Failed: %fail%
                            }
                        Else {
                            mousemove 931, 806 ; Crest Reward
                            sleep 750
                            click
                    PixelGetColor, color, 922, 393, RGB 
                    if (color = 0x141C2C) {
                        isRunning := false
                        SetTimer, CheckReadyButton, Off
                        GuiControl, Status:, StatusText, Status: Stopped
                        MsgBox, 0x40000, Process Terminated, The process has been terminated as you have a 4+ drop or crest burst.
                        ExitApp
                    }

                    }
                        }
                    }
                }
            }
        }
        if (!con2) {
            Sleep 7000
            Mousemove, 862, 626 ; Select Stage
            Click
            Sleep 3000
            Mousemove, 808, 473 ; Single player
            Click
            Sleep 2500
            Mousemove, 895, 919 ; Battle
            Click
            Sleep 2500
            Click
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            counter = 0
            con1 := False
            con2 := True
            }
        }
    Exit the script when the GUI is closed
    GuiClose:
    ExitApp
