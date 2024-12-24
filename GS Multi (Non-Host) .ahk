; Set the path to the button images
readyButtonImage := "ready.png"  ; Replace with the actual path to the "Ready" button image
battleButtonImage := "battle.png"  ; Replace with the actual path to the "Battle" button image
foodButtonImage := "food.png"  ; Replace with the actual path to the "Food" button image
nextButtonImage := "next.png"  ; Replace with the actual path to the "Next" button image
questButtonImage := "quest.png"  ; Replace with the actual path to the "Quest" button image
resultButtonImage := "result.png"  ; Replace with the actual path to the "Result" button image
joinButtonImage := "join.png"  ; Replace with the actual path to the "Join" button image
potsButtonImage := "pots.png"  ; Replace with the actual path to the "Pots" button image
potsOkButtonImage := "potsok.png"  ; Replace with the actual path to the "Pots OK" button image
hostLeftOkButtonImage := "hostleftok.png"  ; Replace with the actual path to the "Host Left OK" button image
disconnectButtonImage := "disconnect.png"  ; Replace with the actual path to the "Disconnect" button image
disconnectlobbyButtonImage := "disconnectlobby.png"  ; Replace with the actual path to the "Disconnect Lobby" button image
inventoryfullButtonImage := "inventoryfull.png"  ; Replace with the actual path to the "Inventory Full" button image


; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
okClicked := false
nextClicked := false
mode := ""
pots := 0
potsClicked := 0

; Create the mode selection GUI
Modes() {
    global
    Gui, Mode: +AlwaysOnTop +Owner
    Gui, Mode: Add, Text,, Select Mode:
    Gui, Mode: Add, Button, gHostingMode w200 h50, Hosting
    Gui, Mode: Add, Button, gNonHostMode w200 h50, Non-Host
    Gui, Mode: Show, x10 y10, Select Mode 
}

Modes()
return

; Hosting mode action
HostingMode:
mode := "Hosting"
Gui, Mode: Destroy
InputBox, pots, Hosting Mode, Enter the number of pots to be used (L pots only):, , 200, 150
if (ErrorLevel)
{
    MsgBox, You cancelled the input. Exiting script.
    ExitApp
}
MsgBox, Make sure you are already in a lobby, set food and have invited farm party before starting.
ShowMainGUI()
return

; Non-Host mode action
NonHostMode:
mode := "Non-Host"
Gui, Mode: Destroy
MsgBox, Make sure you have already set your unit AI, and joined a lobby before starting.
ShowMainGUI()
return

; Show the main control GUI
ShowMainGUI() {
    global
    Gui, Main: +AlwaysOnTop +Owner
    Gui, Main: Add, Tab2, w400 h300, Control|Shortcuts
    Gui, Main: Tab, Control
    Gui, Main: Add, Button, gStartScript w200 h50, Start
    Gui, Main: Add, Button, gPauseScript w200 h50, Pause
    Gui, Main: Add, Button, gStopScript w200 h50, Stop
    Gui, Main: Tab, Shortcuts
    Gui, Main: Add, Text,, F1 - Start
    Gui, Main: Add, Text,, F2 - Pause
    Gui, Main: Add, Text,, F3 - Stop
    Gui, Main: Tab
    Gui, Main: Show, x10 y10, GS Multi (Non-Host) Control

    ; Create the status GUI
    Gui, Status: +AlwaysOnTop +Owner
    Gui, Status: Add, Text, vStatusText, Status: Stopped
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
okClicked := false
nextClicked := false
potsClicked := 0
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
    if (mode = "Hosting")
    {
        HostingModeFunction()
    }
    else
    {
        NonHostModeFunction()
    }
}
return

; Hosting mode function
HostingModeFunction() {
    global
    ; Click the "Pots" button if not all pots have been clicked
    if (potsClicked < pots)
        {
            GuiControl, Status:, StatusText, Status: Looking for Pots button
            ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsButtonImage%
            if (ErrorLevel = 0)
            {
                ImageWidth := 85
                ImageHeight := 30
                centerX := foundX + (ImageWidth // 2) + 10
                centerY := foundY + (ImageHeight // 2)
                MouseMove, %centerX%, %centerY%
                Click
    
                ; Wait until "Pots" button appears again
                Loop
                {
                    GuiControl, Status:, StatusText, Status: Waiting for Pots button to reappear
                    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsButtonImage%
                    if (ErrorLevel = 0)
                    {
                        ; Do not click the "Pots" button again
                        break
                    }
                    Sleep, 100
                }
    
                ; Wait until "Pots" button is not clicked
                Loop
                {
                    GuiControl, Status:, StatusText, Status: Waiting for Pots button to not be clicked
                    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsButtonImage%
                    if (ErrorLevel != 0)
                    {
                        potsClicked++
                        break
                    }
                    Sleep, 100
                }
            }
    
        }
    GuiControl, Status:, StatusText, Status: Looking for Pots OK button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsOkButtonImage%
    if (ErrorLevel = 0)
    {
        ImageWidth := 124
        ImageHeight := 43
        centerX := foundX + (ImageWidth // 2) + 10
        centerY := foundY + (ImageHeight // 2)
        MouseMove, %centerX%, %centerY%
        Click
    }

    ; Search for the "Quest" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Quest button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %questButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Script Stopped, Your script has been stopped either manually, disconnected or you weren't in a farm party.
        ExitApp
        return
    }

    ; Search for the "Battle" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Battle button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %battleButtonImage%
    if (ErrorLevel = 0)
    {
        ImageWidth := 104
        ImageHeight := 42
        centerX := foundX + (ImageWidth // 2) + 10
        centerY := foundY + (ImageHeight // 2)
        MouseMove, %centerX%, %centerY%
        Click
    }
    


    if (!okClicked)
        {
            GuiControl, Status:, StatusText, Status: Looking for Result button
            ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %resultButtonImage%
            if (ErrorLevel = 0)
            {
                ImageWidth := 134
                ImageHeight := 44
                centerX := foundX + (ImageWidth // 2) + 10
                centerY := foundY + (ImageHeight // 2)
                MouseMove, %centerX%, %centerY%
                
                ; Click repeatedly until either "Inventory Full" or "Next" button is identified
                Loop
                    {

                        ImageSearch, invFullX, invFullY, 0, 0, A_ScreenWidth, A_ScreenHeight, %inventoryfullButtonImage%
                        if (ErrorLevel = 0)
                        {
                            ImageWidth := 59
                            ImageHeight := 33
                            centerX := invFullX + (ImageWidth // 2) + 10
                            centerY := invFullY + (ImageHeight // 2)
                            MouseMove, %centerX%, %centerY%
                            ; Click repeatedly until "Next" button is identified
                            Loop
                            {
                                ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
                                if (ErrorLevel = 0)
                                    break
                                Click
                                Sleep, 100
                            }
                            break
                        }
                        ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
                        if (ErrorLevel = 0)
                            break
                        Click
                        Sleep, 100
                        Click
                        Sleep, 100
                    }
                }
            }


    ; Search for the "Next" button image on the screen if it hasn't been clicked yet
    if (!nextClicked)
    {
        GuiControl, Status:, StatusText, Status: Looking for Next button
        ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
        if (ErrorLevel = 0)
        {
            ImageWidth := 134
            ImageHeight := 46
            centerX := foundX + (ImageWidth // 2) + 10
            centerY := foundY + (ImageHeight // 2)
            MouseMove, %centerX%, %centerY%
            Click
            
        }
    }

    ; Search for the "disconnect" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for disconnect button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %disconnectButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Process Terminated, The process has been terminated as you have been disconnected.
        ExitApp
    }
    ; If all pots have been clicked, prompt the user and terminate the script
    if (potsClicked = pots)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Script Stopped, The specified number of pots have been used. The script will now terminate.
        ExitApp
    }
}

; Non-Host mode function
NonHostModeFunction() {
    global
    ; Search for the "Join" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Join button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %joinButtonImage%
    if (ErrorLevel = 0)
    {
        ImageWidth := 100
        ImageHeight := 50
        centerX := foundX + (ImageWidth // 2) + 10
        centerY := foundY + (ImageHeight // 2)
        MouseMove, %centerX%, %centerY%
        Click
    }

    ; Search for the "Food" button image on the screen if it hasn't been clicked yet
    if (!foodClicked)
    {
        GuiControl, Status:, StatusText, Status: Looking for Food button
        ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %foodButtonImage%
        if (ErrorLevel = 0)
        {
            ImageWidth := 92
            ImageHeight := 90
            centerX := foundX + (ImageWidth // 2) + 10
            centerY := foundY + (ImageHeight // 2)
            MouseMove, %centerX%, %centerY%
            Click
            foodClicked := true
        }
    }

    ; Search for the "Ready" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Ready button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %readyButtonImage%
    if (ErrorLevel = 0)
    {
        ImageWidth := 122
        ImageHeight := 51
        centerX := foundX + (ImageWidth // 2) + 10
        centerY := foundY + (ImageHeight // 2)
        MouseMove, %centerX%, %centerY%
        Click
    }

    ; Search for the "Quest" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Quest button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %questButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Script Stopped, Your script has been stopped either manually, disconnected or you weren't in a farm party.
        ExitApp
        return
    }

    if (!okClicked)
        {
            GuiControl, Status:, StatusText, Status: Looking for Result button
            ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %resultButtonImage%
            if (ErrorLevel = 0)
            {
                ImageWidth := 134
                ImageHeight := 44
                centerX := foundX + (ImageWidth // 2) + 10
                centerY := foundY + (ImageHeight // 2)
                MouseMove, %centerX%, %centerY%
                
                ; Click repeatedly until either "Inventory Full" or "Next" button is identified
                Loop
                {
                    ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
                    if (ErrorLevel = 0)
                        break
                    Click
                    Sleep, 100
                    ImageSearch, invFullX, invFullY, 0, 0, A_ScreenWidth, A_ScreenHeight, %inventoryfullButtonImage%
                    if (ErrorLevel = 0)
                    {
                        ImageWidth := 59
                        ImageHeight := 33
                        centerX := invFullX + (ImageWidth // 2) + 10
                        centerY := invFullY + (ImageHeight // 2)
                        MouseMove, %centerX%, %centerY%
                        ; Click repeatedly until "Next" button is identified
                        Loop
                        {
                            ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
                            if (ErrorLevel = 0)
                                break
                            Click
                            Sleep, 100
                        }
                        break
                    }
                    Click
                    Sleep, 100
                }
            }
        }
    ; Search for the "Next" button image on the screen if it hasn't been clicked yet
    if (!nextClicked)
    {
        GuiControl, Status:, StatusText, Status: Looking for Next button
        ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
        if (ErrorLevel = 0)
        {
            ImageWidth := 134
            ImageHeight := 46
            centerX := foundX + (ImageWidth // 2) + 10
            centerY := foundY + (ImageHeight // 2)
            MouseMove, %centerX%, %centerY%
            Click
            
        }
    }

    ; Search for the "Host Left OK" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for Host Left OK button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %hostLeftOkButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Process Terminated, The process has been terminated as host has left.
        ExitApp
    }

    ; Search for the "disconnect" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for disconnect button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %disconnectButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Process Terminated, The process has been terminated as you have been disconnected.
        ExitApp
    }
    ; Search for the "disconnect lobby" button image on the screen
    GuiControl, Status:, StatusText, Status: Looking for disconnect lobby button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %disconnectlobbyButtonImage%
    if (ErrorLevel = 0)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, Status:, StatusText, Status: Stopped
        MsgBox, 0x40000, Process Terminated, The process has been terminated as you have been disconnected.
        ExitApp
    }
}

; Exit the script when the GUI is closed
GuiClose:
ExitApp