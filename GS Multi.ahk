
; Set the path to the button images
readyButtonImage := "pic/ready.png"  ; Replace with the actual path to the "Ready" button image
battleButtonImage := "pic/battle.png"  ; Replace with the actual path to the "Battle" button image
foodButtonImage := "pic/food.png"  ; Replace with the actual path to the "Food" button image
nextButtonImage := "pic/next.png"  ; Replace with the actual path to the "Next" button image
questButtonImage := "pic/quest.png"  ; Replace with the actual path to the "Quest" button image
resultButtonImage := "pic/result.png"  ; Replace with the actual path to the "Result" button image
joinButtonImage := "pic/join.png"  ; Replace with the actual path to the "Join" button image
potsButtonImage := "pic/pots.png"  ; Replace with the actual path to the "Pots" button image
hostLeftOkButtonImage := "pic/hostleftok.png"  ; Replace with the actual path to the "Host Left OK" button image
disconnectButtonImage := "pic/disconnect.png"  ; Replace with the actual path to the "Disconnect" button image
disconnectlobbyButtonImage := "pic/disconnectlobby.png"  ; Replace with the actual path to the "Disconnect Lobby" button image

; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
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
    Gui, Status: Add, Text, vPotsUsedText, Pots Used: %potsClicked%/%pots%
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
    GuiControl, Status:, StatusText, Status: Looking for Pots button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsButtonImage%
    if (ErrorLevel = 0)
    {
        potsClicked++
        GuiControl, Status:, PotsUsedText, Pots Used: %potsClicked%/%pots%
    }

    if (potsClicked <= pots)
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

            ; Wait for 0.5 seconds before clicking on coordinates (945, 546)
            Sleep, 500
            MouseMove, 945, 546
            Click

            ; Wait until "Pots" button appears again
        }
    }

    if (potsClicked > pots)
    {
        isRunning := false
        SetTimer, CheckReadyButton, Off
        GuiControl, , StatusText, Status: Stopped
        MsgBox, 0x40000, Script Stopped, %pots% pots have been used up. The script will now terminate.
        ExitApp
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
            Click
            ; Click repeatedly on coordinates (938, 641) until "Next" button is identified
            Loop
            {
                ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextButtonImage%
                if (ErrorLevel = 0)
                    break
                MouseMove, 938, 670
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
condition1 := False
condition2 := False
condition3 := False
condition4 := False

NonHostModeFunction() { 
    global
    ; Check if the pixel at (827, 658) is color 
    if (!condition1) {
        PixelGetColor, color, 827, 658, RGB
        if (color = 0xEDEDED) {
            GuiControl, Status:, StatusText, Status: Clicking on coordinates (827, 658)
            Click 827, 658
            Sleep, 1000 ; Wait for 1 second to simulate the click delay
            condition1 := True
        }
    }   

    ; Check for colors starting with 0x844###
    PixelGetColor, colorCheck, 801, 837, RGB
    if (colorCheck >= 0x844000 && colorCheck <= 0x844FFF && !condition2) {
        GuiControl, Status:, StatusText, Status: Clicking on coordinates (718, 810)
        Click 718, 810
        Sleep, 1000 ; Wait for 1 second to simulate the click delay
        condition2 := True ; Activate condition2 if the color is in the specified range
    }

    if (condition2 && !condition2) {
        GuiControl, Status:, StatusText, Status: Clicking on coordinates (718, 810)
        Click 718, 810
        Sleep, 1000 ; Wait for 1 second to simulate the click delay
        condition2 := True
    }

    if (!condition3) {
        PixelGetColor, color, 935, 980, RGB
        if (color = 0xF75918) {
            GuiControl, Status:, StatusText, Status: Clicking on coordinates (935, 980)
            Click 935, 980
            Sleep, 1000 ; Wait for 1 second to simulate the click delay
            condition3 := True
        }
    }

    if (!condition4) {
        PixelGetColor, color, 934,221, RGB
        if (color = 0xA4A6A4) {
            GuiControl, Status:, StatusText, Status: Clicking on coordinates (934, 221)
            Mousemove, 943, 666
            Click
            Sleep, 1000
            Loop
                {
                    Click
                    PixelGetColor, color, 948, 832, RGB
                    if (color = 0x212421) {
                        GuiControl, Status:, StatusText, Status: Clicking on coordinates (948, 832)
                        Mousemove, 948, 832
                        Click
                        Sleep, 100
                        condition3 := False
                        break
                    }
                }
        }
    }
}





Exit the script when the GUI is closed
GuiClose:
ExitApp