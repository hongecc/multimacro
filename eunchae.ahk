
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
crestButtonImage := "pic/crest.png"  ; Replace with the actual path to the "Crest" button image
crestTickedImage := "pic/crestticked.png"  ; Replace with the actual path to the "Crest Ticked" button image
; Initialize variables
isRunning := false
isPaused := false
foodClicked := false
mode := ""
pots := 0
potsClicked := 000
crestClicked := false
fourplus := 0
rounds := 000
loops := 000
MaxLoops = 000
fail := 000
help := 000

; Create the mode selection GUI
Modes() {
    global
    Gui, Mode: +AlwaysOnTop +Owner
    Gui, Mode: Add, Text,, Select Mode:
    Gui, Mode: Add, Button, gHostingMode w200 h50, Hosting
    Gui, Mode: Add, Button, gNonHostMode w200 h50, Non-Host
    Gui, Mode: Add, Button, gCrestNonHostMode w200 h50, Crest Non-Host
    Gui, Mode: Add, Button, gAutoCompendium w200 h50, Auto Compendium
    Gui, Mode: Add, Button, gAutoCrest w200 h50, Auto Crest
    Gui, Mode: Add, Button, gAutoQuest w200 h50, Auto Quest
    Gui, Mode: Add, Button, gAutoHelper w200 h50, Auto Helper
    Gui, Mode: Show, x10 y10, Select Mode 
}

Modes()
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
MaxLoops = 2
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

CrestNonHostMode:
mode := "Crest Non-Host"
Gui, Mode: Destroy
Msgbox, Make sure you have already set your unit AI, and joined a lobby before starting.
ShowMainGUI()
Return
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

AutoQuest:
mode := "Auto Quest"
Gui, Mode: Destroy
MsgBox, Make sure you have already started the l00p at raid boss practice before starting.
ShowMainGUI()
return

AutoHelper:
mode := "Auto Helper"
Gui, Mode: Destroy
MsgBox, Make sure you have set a luck unit as first unit before proceeding.
ShowMainGUI()
Return

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
    Gui, Status: Add, Text, vRounds, Rounds: %rounds%
    Gui, Status: Add, Text, vLoops, Times Looped: %loops%
    Gui, Status: Add, Text, vFailed, Times Failed: %fail%
    Gui, Status: Add, Text, vHelpers, Helpers Done: %help%
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
crestClicked := false
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
    else if (mode = "Non-Host")
    {
        NonHostModeFunction()
    }
    else if (mode = "Crest Non-Host")
    {
        CrestNonHostModeFunction()
    }
    else if (mode = "Auto Compendium") {
        AutoCompendium()
    }
    else if (mode = "Auto Crest") {
        AutoCrest()
    }
    else if (mode = "Auto Quest") {
        AutoQuest()
    } 
    else if (mode = "Auto Helper") {
        AutoHelper()
    }
}

return


; Hosting mode function
HostingModeFunction() {
    global
    ; Click the "Pots" button if not all pots have been clicked
    GuiControl, Status:, StatusText, Status: Looking for Pots button
    ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %potsButtonImage%
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
            Sleep, 1500
            MouseMove, 930, 546
            Click
            potsClicked++
            GuiControl, Status:, PotsUsedText, Pots Used: %potsClicked%/%pots%
            sleep 100

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
            rounds++
            GuiControl, Status:, Rounds, Rounds: %rounds%
            sleep 500
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
        if (color = 0xFF581F) {
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
                PixelGetColor, color, 949, 821, RGB ; Next Button
                if (color = 0xFF7918) {
                    GuiControl, Status:, StatusText, Status: clicknext
                    Sleep, 800
                    Click 949, 821 ; Next Button
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

Crests() {
    global
    Gui, Crests: New
    Gui, Crests: Add, Text,, Select Crests:
    Gui, Crests: Add, Button, gOneCrest w200 h50, One Crest
    Gui, Crests: Add, Button, gTwoCrest w200 h50, Two Crests
    Gui, Crests: Add, Button, gThreeCrest w200 h50, Three Crests
    Gui, Crests: Show, x10 y10
}

OneCrest:
    fourplus := 1
    Gui, Crests: Destroy
    who := True
    MsgBox, You have selected One Crest.
return

TwoCrest:
    fourplus := 2
    Gui, Crests: Destroy
    who := True
    MsgBox, You have selected Two Crest.
return

ThreeCrest:
    fourplus := 3
    Gui, Crests: Destroy   
    who := True
    MsgBox, You have selected Three Crest.
return

who := False
; Non-Host mode function
CrestNonHostModeFunction() {
    global
    if (!who)
    {
        Crests()
    }
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
                ; Click repeatedly on coordinates (938, 641) until "Next" button is identified
                rounds++
                GuiControl, Status:, Rounds, Rounds: %rounds%
                sleep 500
                Loop
                {
                    ImageSearch, nextX, nextY, 0, 0, A_ScreenWidth, A_ScreenHeight, %cresttickedImage%
                    if (ErrorLevel = 0)
                        break
                    MouseMove, 938, 771
                    Click
                    Sleep, 100
                }
            }
        }
    if (!crestClicked)
        {
            GuiControl, Status:, StatusText, Status: Looking for Crest button
            ImageSearch, foundx, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %crestButtonImage%
            if (ErrorLevel = 0)
            {
                isRunning := false
                SetTimer, CheckReadyButton, Off
                GuiControl, Status:, StatusText, Status: Stopped
                MsgBox, 0x40000, Process Terminated, The process has been terminated as you have 4+
                ExitApp
             }
            else 
            {
                ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %cresttickedImage%
                if (ErrorLevel = 0)
                {
                    if (fourplus = 1)
                    {
                            MouseMove, 1149, 428
                            Click
                            Sleep 500
                            Mousemove, 981, 887
                            Click
                            Sleep 100
                            Mousemove, 827, 701
                            Click
                            crestClicked := true
                    }
                    else if (fourplus = 2)
                    { 
                    MouseMove, 1149, 710
                    Click
                    Sleep 100
                    MouseMove, 1149, 428
                    Click
                    Sleep 100
                    MouseMove, 1149, 577
                    Click
                    Sleep 500
                    Mousemove, 981, 887
                    Click
                    Sleep 100
                    Mousemove, 827, 701
                    Click
                    crestClicked := true
                    }
                    else 
                    {

                        MouseMove, 1149, 428
                        Click
                        Sleep 100
                        MouseMove, 1149, 577
                        Click
                        Sleep 500
                        Mousemove, 981, 887
                        Click
                        Sleep 100
                        Mousemove, 827, 701
                        Click
                        crestClicked := true

                    }
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
con := False
con1 := False
con2 := True

AutoCompendium() {
    global
    {
    PixelGetColor, color, 955, 471, RGB ; reSult
    if (color = 0xD7D7D7) { 
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
            Sleep 5000
            Mousemove, 996, 980
            Click
            Sleep 3000
            con1 := True
            con2 := False
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
            Sleep 3500
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
            Mousemove 937, 880
            Sleep 2500
            Click
            Sleep 2500
            Click
            con := True 
        }
        if (!con1) {
            Loop {
                if (counter+1 = MaxLoops) {
                    PixelGetColor, color, 1140, 987, RGB ; End Battle
                    if (color = 0xB2B1B2) {
                        Sleep, 750
                        Mousemove, 1140, 987 ; End Battle 
                        Click
                        Sleep, 1500
                        Mousemove, 933, 763 ; Crest Reward
                        Click
                        Sleep, 1000
                        Click
                        Sleep, 1000
                        Click
                        Mousemove, 942, 979 ; Ok
                        Sleep, 1000
                        Click
                        GuiControl, Status:, StatusText, Status: Restarting
                        con2 := False
                        con1 := True
                        break
                    }
                }
                else if (counter < MaxLoops) {
                    PixelGetColor, color, 967, 476, RGB ; Start
                    if (color = 0x043152) { 
                        counter++
                        rounds++
                        GuiControl, Status:, Rounds, Rounds: %rounds%
                        Sleep 4500
                        }
                else {
                    PixelGetColor, color, 1101, 610 ; Cancel
                    if (color = 0x484848) {
                        Mousemove, 1093, 600 ; Cancel
                        Click
                        Sleep, 1000
                        Mousemove, 923, 636 ; Restart
                        Click
                        fail++
                        counter--
                        rounds--
                        GuiControl, Status:, Failed, Times Failed: %fail%
                        }
                    Else {
                        mousemove 943, 756 ; Crest Reward
                        sleep 750
                        click
                PixelGetColor, color, 939, 375, RGB 
                if (color = 0xFBF8FB) {
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
        Mousemove, 874, 577 ; Select Stage
        Click
        Sleep 3000
        Mousemove, 800, 461 ; Single player
        Click
        Sleep 2500
        Mousemove, 936, 872 ; Battle
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

AutoQuest() {
    global
    {
    if (!con) {
        Click 937, 880
        Sleep 1000
        Click
        Sleep 1000
        Click
        con := True
    }
    if (!con1) {
        PixelGetColor, color, 940, 982, RGB ; Ok Button
    if (color = 0xCDCCCD) {
            mousemove, 940, 979
            Sleep 5000
            Click
            Mousemove, 893, 329
            con1 := True
            con2 := False
            }
        PixelGetColor, color, 935, 477, RGB ; Start Message
        if (color = 0x002341) { 
            rounds++
            GuiControl, Status:, Rounds, Rounds: %rounds%
            Sleep 5000
            }
        else {
            mousemove 944, 668
            Click
            }
        }
    }
    if (!con2) {
        PixelGetColor, color, 893, 329, RGB ; Stage
        if (color = 0x182029) {
            Mousemove, 893, 329 ; Stage
            Sleep 750
            Click
            Sleep 1500
            Mousemove, 937, 880 ; Battle
            Sleep 750
            Click
            Sleep 750
            Click
            GuiControl, Status:, StatusText, Status: Restarting
            loops++
            GuiControl, Status:, Loops, Times Looped: %loops%
            con1 := False
            con2 := True
        }
    }
}
party := False
AutoHelper() {
    global
    {
        if (!con) {
            PixelGetColor, color, ###, ###, RGB ; Join Multi
            if (color = 0x######) {
                Mousemove, ###, ### ; Join Multi
                Click
                Sleep 1000
                Mousemove, ###, ### ; Team Setup Battle Button
                Click
                Sleep 5000
                Mousemove, ###, ### ; Stage Filter 
                Click
                Sleep 3000
                con := True
                con1 := True
            }
        }
        if (!con3) {
            con1 := True
            con3 := True
        }

        if (con1) {
            Loop {
                Mousemove, ###, ### ; Daily Quest
                Click
                Sleep 500
                Mousemove, ###, ### ; Daily Quest Stage
                Click 
                ; Check four coordinates for specific colors
                PixelGetColor, color1, x1, y1, RGB ; Helper on Stage 1, Coordinate 1
                PixelGetColor, color2, x2, y2, RGB ; Helper on Stage 2, Coordinate 2
                PixelGetColor, color3, x3, y3, RGB ; Helper on Stage 3, Coordinate 3
                PixelGetColor, color4, x4, y4, RGB ; Helper on Stage 4, Coordinate 4
                
                if (color1 = 0x######) {
                    Mousemove, x1, y1 ; Move to Coordinate 1
                    Click
                    con1 := False
                    con2 := False
                    Break
                } else if (color2 = 0x######) {
                    Mousemove, x2, y2 ; Move to Coordinate 2
                    Click
                    con1 := False
                    con2 := False
                    Break
                } else if (color3 = 0x######) {
                    Mousemove, x3, y3 ; Move to Coordinate 3
                    Click
                    con1 := False
                    con2 := False
                    Break
                } else if (color4 = 0x######) {
                    Mousemove, x4, y4 ; Move to Coordinate 4
                    Click
                    con1 := False
                    con2 := False
                    Break
                }
                else {
                    Mousemove, ###, ### ; Stage Filter
                    Click
                    Sleep 2000
                    Loop {
                        Mousemove, ###, ### ; Point below Stage Filter to scroll
                        Sleep 100
                        PixelGetColor, color, ###, ###, RGB ; Scrolling Till Unit Exp
                        if (color = 0x######) { ; Unit Exp Stage Colour
                            break
                        }
                        Send {WheelDown}
                        Sleep 100
                    }
                    Mousemove, ###, ### ; Unit Exp
                    Click
                    Sleep 500
                    Mousemove, ###, ### ; Unit Exp Stage
                    Click
                    Sleep 500
                    ; Check four coordinates for specific colors
                    PixelGetColor, color1, x1, y1, RGB ; Helper on Stage 1, Coordinate 1
                    PixelGetColor, color2, x2, y2, RGB ; Helper on Stage 2, Coordinate 2
                    PixelGetColor, color3, x3, y3, RGB ; Helper on Stage 3, Coordinate 3
                    PixelGetColor, color4, x4, y4, RGB ; Helper on Stage 4, Coordinate 4
                    
                    if (color1 = 0x######) {
                        Mousemove, x1, y1 ; Move to Coordinate 1
                        Click
                        con1 := False
                        con2 := False
                        Break
                    } else if (color2 = 0x######) {
                        Mousemove, x2, y2 ; Move to Coordinate 2
                        Click
                        con1 := False
                        con2 := False
                        Break
                    } else if (color3 = 0x######) {
                        Mousemove, x3, y3 ; Move to Coordinate 3
                        Click
                        con1 := False
                        con2 := False
                        Break
                    } else if (color4 = 0x######) {
                        Mousemove, x4, y4 ; Move to Coordinate 4
                        Click
                        con1 := False
                        con2 := False
                        Break
                    }
                    else {
                        Mousemove, ###, ### ; Stage Filter
                        Click 
                        Sleep 2000
                        Mousemove, ###, ### ; Bottom Stage
                        Click
                        Sleep 500
                        Mousemove, ###, ### ; Bottom Stage Select
                        ; Check four coordinates for specific colors
                        PixelGetColor, color1, x1, y1, RGB ; Helper on Stage 1, Coordinate 1
                        PixelGetColor, color2, x2, y2, RGB ; Helper on Stage 2, Coordinate 2
                        PixelGetColor, color3, x3, y3, RGB ; Helper on Stage 3, Coordinate 3
                        PixelGetColor, color4, x4, y4, RGB ; Helper on Stage 4, Coordinate 4
                        
                        if (color1 = 0x######) {
                            Mousemove, x1, y1 ; Move to Coordinate 1
                            Click
                            con1 := False
                            con2 := False
                            Break
                        } else if (color2 = 0x######) {
                            Mousemove, x2, y2 ; Move to Coordinate 2
                            Click
                            con1 := False
                            con2 := False
                            Break
                        } else if (color3 = 0x######) {
                            Mousemove, x3, y3 ; Move to Coordinate 3
                            Click
                            con1 := False
                            con2 := False
                            Break
                        } else if (color4 = 0x######) {
                            Mousemove, x4, y4 ; Move to Coordinate 4
                            Click
                            con1 := False
                            con2 := False
                            Break
                        }
                        else {
                            Mousemove, ###, ### ; Stage Filter
                            Click 
                            Sleep 2000
                            Mousemove, ###, ### ; Bottom Stage
                            Click
                            Sleep 500
                            Mousemove, ###, ### ; Bottom Stage Select
                            ; Check four coordinates for specific colors
                            PixelGetColor, color1, x1, y1, RGB ; Helper on Stage 1, Coordinate 1
                            PixelGetColor, color2, x2, y2, RGB ; Helper on Stage 2, Coordinate 2
                            PixelGetColor, color3, x3, y3, RGB ; Helper on Stage 3, Coordinate 3
                            PixelGetColor, color4, x4, y4, RGB ; Helper on Stage 4, Coordinate 4
                            
                            if (color1 = 0x######) {
                                Mousemove, x1, y1 ; Move to Coordinate 1
                                Click
                                con1 := False
                                con2 := False
                                Break
                            } else if (color2 = 0x######) {
                                Mousemove, x2, y2 ; Move to Coordinate 2
                                Click
                                con1 := False
                                con2 := False
                                Break
                            } else if (color3 = 0x######) {
                                Mousemove, x3, y3 ; Move to Coordinate 3
                                Click
                                con1 := False
                                con2 := False
                                Break
                            } else if (color4 = 0x######) {
                                Mousemove, x4, y4 ; Move to Coordinate 4
                                Click
                                con1 := False
                                con2 := False
                                Break
                            }
                            else {
                                Mousemove, ###, ### ; Stage Filter
                                Click 
                                Sleep 2000
                                Mousemove, ###, ### ; Bottom Stage
                                Click
                                Sleep 500
                                Mousemove, ###, ### ; Bottom Stage Select
                            
                                ; Check four coordinates for specific colors
                                PixelGetColor, color1, x1, y1, RGB ; Helper on Stage 1, Coordinate 1
                                PixelGetColor, color2, x2, y2, RGB ; Helper on Stage 2, Coordinate 2
                                PixelGetColor, color3, x3, y3, RGB ; Helper on Stage 3, Coordinate 3
                                PixelGetColor, color4, x4, y4, RGB ; Helper on Stage 4, Coordinate 4
                                
                                if (color1 = 0x######) {
                                    Mousemove, x1, y1 ; Move to Coordinate 1
                                    Click
                                    con1 := False
                                    con2 := False
                                    Break
                                } else if (color2 = 0x######) {
                                    Mousemove, x2, y2 ; Move to Coordinate 2
                                    Click
                                    con1 := False
                                    con2 := False
                                    Break
                                } else if (color3 = 0x######) {
                                    Mousemove, x3, y3 ; Move to Coordinate 3
                                    Click
                                    con1 := False
                                    con2 := False
                                    Break
                                } else if (color4 = 0x######) {
                                    Mousemove, x4, y4 ; Move to Coordinate 4
                                    Click
                                    con1 := False
                                    con2 := False
                                    Break
                                }
                                  else {
                                    Mousemove, ###, ### ; Stage Filter
                                    Click 
                                    Sleep 2000
                                    Loop {
                                        Mousemove, ###, ### ; Point below Stage Filter to scroll
                                        Click
                                        Sleep 100
                                        PixelGetColor, color, ###,###, RGB ; 
                                        if (color = 0x######) { 
                                            con3 := False
                                            con1 := False
                                            break
                                        }
                                        Send {WheelUp}
                                        Sleep 100
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }

    if (!con2) {
        if (!condition1) {
            PixelGetColor, color, 827, 658, RGB
            if (color = 0xEDEDED) {
                GuiControl, Status:, StatusText, Status: joinparty ; Join Party
                party := True
                Click 827, 658
                Sleep, 1000 ; Wait for 1 second to simulate the click delay
                condition1 := True
            }
        }   
        if (!condition2) {
            GuiControl, Status:, StatusText, Status: food
            Click 718, 810 ; Food
            Sleep, 500
            condition2 := True
        }
    
        if (!condition3 && condition2) {
            GuiControl, Status:, StatusText, Status: ready
            PixelGetColor, color, 867, 987, RGB ; Ready Button
            if (color = 0xFF581F) {
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
                    PixelGetColor, color, 949, 821, RGB ; Next Button
                    if (color = 0xFF7918) {
                        GuiControl, Status:, StatusText, Status: clicknext
                        Sleep, 800
                        Click 949, 821 ; Next Button
                        Sleep, 100
                        condition4 := True
                        rounds++
                        GuiControl, Status:, rounds, Rounds: %rounds%
                        break
                    }
                }
            }
        }
        if (party) {
            Mousemove, ###, ### ; Leave Lobby 
            Click
            Sleep 500
            Mousemove, ###, ### ; Confirm
            Click
            party := False
            con1 := True
            con2 := False
        }
        else {
            con := False
            con2 := True
        }
    }
    
    }
}
; Exit the script when the GUI is closed
GuiClose:
ExitApp
