func optionsgui();create the GUI of options
   #Region ### START Koda GUI section ### Form=
   $Form2 = GUICreate($windowname, 1017, 365, 192, 124)
   $Tab1 = GUICtrlCreateTab(0, 0, 1017, 337)
   $TabSheet1 = GUICtrlCreateTabItem("General")
   $Label1 = GUICtrlCreateLabel("In-game Screen Resolution", 32, 32, 132, 17)
   $xresin = GUICtrlCreateInput($screenres[1], 32, 56, 41, 21)
   $Label2 = GUICtrlCreateLabel("X", 16, 59, 11, 17)
   $Label3 = GUICtrlCreateLabel("Y", 80, 59, 11, 17)
   $yresin = GUICtrlCreateInput($screenres[2], 96, 56, 41, 21)
   $Label4 = GUICtrlCreateLabel("In-game Sensibility - (use sensibility 1, its not working)", 32, 112, 91, 17)
   $sensin = GUICtrlCreateInput($sensibility, 24, 136, 65, 21)
   $lookonlinebox = GUICtrlCreateCheckbox("Look for Address online", 32, 192, 137, 17)
   if $lookonline = 1 then
      GUICtrlSetState(-1, $GUI_CHECKED)
   EndIf
   $TabSheet2 = GUICtrlCreateTabItem("Relax")
   $Label5 = GUICtrlCreateLabel('Timing correction - (relax will tap x miliseconds before, "x" is random between min and max, change this to improve undetectability', 32, 32, 611, 17)
   $accminin = GUICtrlCreateInput($accmin, 40, 56, 41, 21)
   $Label6 = GUICtrlCreateLabel("Min", 16, 59, 21, 17)
   $Label7 = GUICtrlCreateLabel("Max", 88, 59, 24, 17)
   $accmaxin = GUICtrlCreateInput($accmax, 112, 56, 41, 21)
   $Label8 = GUICtrlCreateLabel('Hold Button/Mouse - (relax will hold button for x miliseconds before releasing it, "x" is random between min and max, change this to improve undetectability)', 32, 112, 732, 17)
   $Label9 = GUICtrlCreateLabel("Min", 16, 139, 21, 17)
   $holdminin = GUICtrlCreateInput($holdmin, 40, 136, 41, 21)
   $Label10 = GUICtrlCreateLabel("Max", 88, 139, 24, 17)
   $holdmaxin = GUICtrlCreateInput($holdmax, 112, 136, 41, 21)
   $Label11 = GUICtrlCreateLabel("Single tap interval - (the interval between single taps, if the time between a note and another is lower than this value than the relax will tab the secondary button)", 32, 192, 755, 17)
   $maxintervalin = GUICtrlCreateInput($maxinterval, 24, 216, 65, 21)
   $Label12 = GUICtrlCreateLabel("Buttons - (the primary and secondary keyboard buttons set in your game options, reverse it if you tap then reversed and check mouse buttons to use mouse clicks)", 32, 272, 766, 17)
   $key1in = GUICtrlCreateInput($key[1], 24, 296, 33, 21)
   $Label13 = GUICtrlCreateLabel("1", 16, 299, 10, 17)
   $Label14 = GUICtrlCreateLabel("2", 64, 299, 10, 17)
   $key2in = GUICtrlCreateInput($key[2], 72, 296, 33, 21)
   $mousebox = GUICtrlCreateCheckbox("Mouse buttons", 120, 296, 97, 17)
   if $usemouse = 1 Then
	  GUICtrlSetState(-1, $GUI_CHECKED)
	  guictrlsetstate($key1in,$GUI_DISABLE)
	  guictrlsetstate($key2in,$GUI_DISABLE)
   EndIf
   $Label20 = GUICtrlCreateLabel("All values in Miliseconds - (0 or negative in max value is not recommended but some fast songs may require lower values)", 152, 59, 571, 17)
   $Label21 = GUICtrlCreateLabel("All values in Miliseconds - (0 is not recommended but some fast songs may require lower values)", 152, 139, 453, 17)
   $Label22 = GUICtrlCreateLabel("Miliseconds - (for single tap only set this value to 0)", 88, 219, 242, 17)
   $TabSheet3 = GUICtrlCreateTabItem("Aimcorrection")
   $Label15 = GUICtrlCreateLabel("Correction Radius - (the range from the center of the note the Aimcorrection will take effect)", 32, 32, 432, 17)
   $correctionradiusin = GUICtrlCreateInput($correctionradius, 24, 56, 97, 21)
   $Label16 = GUICtrlCreateLabel("Y Correction - (the center of the note is drawn a bit higher than it should, this value correct it, it might change depending on your in-game resolution, change this to the value that best fits the center of the note)", 32, 112, 979, 17)
   $ycorrectionin = GUICtrlCreateInput($ycorrection, 24, 136, 97, 21)
   $Label27 = GUICtrlCreateLabel("Pixels", 120, 59, 31, 17)
   $Label28 = GUICtrlCreateLabel("Pixels", 120, 139, 31, 17)
   $TabSheet4 = GUICtrlCreateTabItem("Aimbot")
   ;GUICtrlSetState(-1,$GUI_SHOW)
   $Label17 = GUICtrlCreateLabel("Time to move mouse - (x miliseconds before the note appear it will start moving the mouse)", 32, 32, 427, 17)
   $movetimein = GUICtrlCreateInput($movetime, 24, 56, 89, 21)
   $Label18 = GUICtrlCreateLabel("Miliseconds", 112, 59, 59, 17)
   $Label19 = GUICtrlCreateLabel("Slider Timing Correction - (Aimbot will treat sliders as it was x miliseconds before)", 32, 112, 377, 17)
   $slideraccin = GUICtrlCreateInput($slideracc, 24, 136, 73, 21)
   $Label23 = GUICtrlCreateLabel("Miliseconds", 96, 139, 59, 17)
   $Label24 = GUICtrlCreateLabel("Slider Speed multiplier - (multiplier for slider speed, 0.95 will do but some 3+way sliders may have desync)", 32, 192, 493, 17)
   $sliderspdcorrectionin = GUICtrlCreateInput($sliderspdcorrection, 24, 216, 121, 21)
   $Label25 = GUICtrlCreateLabel("Y Correction - (the center of the note is drawn a bit higher than it should, this value correct it, it might change depending on your in-game resolution, change this to the value that best fits the center of the note)", 32, 272, 979, 17)
   $ycorrectionaltin = GUICtrlCreateInput($ycorrection, 24, 296, 49, 21)
   $Label26 = GUICtrlCreateLabel("Pixels", 72, 299, 31, 17)
   $TabSheet5 = GUICtrlCreateTabItem("Auto Spin")
   $Label27 = GUICtrlCreateLabel("Circle Radius - (circle radius is a random value between min and max)",32,32,333,17)
   $Label28 = GUICtrlCreateLabel("Min", 16, 59, 21, 17)
   $spinlineminin = GUICtrlCreateInput($spinlinemin, 40, 56, 41, 21)
   $Label29 = GUICtrlCreateLabel("Max", 88, 59, 24, 17)
   $spinlinemaxin = GUICtrlCreateInput($spinlinemax, 112, 56, 41, 21)
   $Label30 = GUICtrlCreateLabel("Max circle variation - (Circle will change its radius during spin in a random value up to the difference of circle variation)",32,112,600,17)
   $spinvariationin = GUICtrlCreateInput($spinvariation,24,136,73,21)
   $Label31 = guictrlcreateLabel("Spins per second",32,192,100,17)
   $spinspsin = GUICtrlCreateInput($spinsps,24,216,73,21)
   GUICtrlCreateTabItem("")
   $okbutton = GUICtrlCreateButton("Ok", 0, 336, 75, 25)
   $cancelbutton = GUICtrlCreateButton("Cancel", 224, 336, 75, 25)
   GUISetState(@SW_SHOW,$Form2)
   #EndRegion ### END Koda GUI section ###

   While 1
      $nMsg = GUIGetMsg()
      Switch $nMsg
	     Case $GUI_EVENT_CLOSE
		    exitloop
         Case $mousebox
			if guictrlread($mousebox) = $GUI_CHECKED Then
			   guictrlsetstate($key1in,$GUI_DISABLE)
			   guictrlsetstate($key2in,$GUI_DISABLE)
			Else
			   guictrlsetstate($key1in,$GUI_ENABLE)
			   guictrlsetstate($key2in,$GUI_ENABLE)
			EndIf
		 Case $okbutton
			if guictrlread($ycorrectionin) = guictrlread($ycorrectionaltin) then
			$movetime = number(guictrlread($movetimein))
			$correctionradius =  number(guictrlread($correctionradiusin))
			$accmin =  number(guictrlread($accminin))
			$accmax =  number(guictrlread($accmaxin))
			$holdmin =  number(guictrlread($holdminin))
			$holdmax =  number(guictrlread($holdmaxin))
			$maxinterval =  number(guictrlread($maxintervalin))
			$ycorrection =  number(guictrlread($ycorrectionin))
			$slideracc =  number(guictrlread($slideraccin))
			$sliderspdcorrection =  number(guictrlread($sliderspdcorrectionin))
			$screenres[1] =  number(guictrlread($xresin))
			$screenres[2] =  number(guictrlread($yresin))
			$sensibility =  number(guictrlread($sensin))
			$key[1] = guictrlread($key1in)
			$key[2] = guictrlread($key2in)
			$spinlinemin = number(guictrlread($spinlineminin))
			$spinlinemax = number(guictrlread($spinlinemaxin))
			$spinvariation = number(guictrlread($spinvariationin))
			$spinsps = number(guictrlread($spinspsin))
			if guictrlread($mousebox) = $GUI_CHECKED then
			   $usemouse = 1
		    Else
			   $usemouse = 0
			EndIf
			if guictrlread($lookonlinebox) = $GUI_CHECKED then
			   $lookonline = 1
			Else
			   $lookonline = 0
			EndIf
			iniwrite($config,"GENERAL","screenresolution",$screenres[1] & "x" & $screenres[2])
			iniwrite($config,"GENERAL","sensibility",$sensibility)
			iniwrite($config,"GENERAL","lookonline",$lookonline)
			iniwrite($config,"relax","accmin",$accmin)
			iniwrite($config,"relax","accmax",$accmax)
			iniwrite($config,"relax","holdmin",$holdmin)
			iniwrite($config,"relax","holdmax",$holdmax)
			iniwrite($config,"relax","maxinterval",$maxinterval)
			iniwrite($config,"relax","key",$key[1] & "," & $key[2])
			iniwrite($config,"relax","usemouse",$usemouse)
			iniwrite($config,"aimcorrection","correctionradius",$correctionradius)
			iniwrite($config,"aim","ycorrection",$ycorrection)
			iniwrite($config,"aimbot","movetime",$movetime)
			iniwrite($config,"aimbot","slideracc",$slideracc)
			iniwrite($config,"aimbot","sliderspdcorrection",$sliderspdcorrection)
			iniwrite($config,"autospin","spinlinemin",$spinlinemin)
			iniwrite($config,"autospin","spinlinemax",$spinlinemax)
			iniwrite($config,"autospin","spinvariation",$spinvariation)
			iniwrite($config,"autospin","spinsps",$spinsps)
			exitloop
			Else
            msgbox(0,"Error","Y correction of aimbot and aim correction need to be of the same value")
		    EndIf
		 case $cancelbutton
			exitloop
	  EndSwitch
   WEnd
   guidelete($form2)
EndFunc

func hotkeysgui();create the GUI of hotkeys
   #Region ### START Koda GUI section ### Form=
   $Form3 = GUICreate("Form1", 193, 177, 276, 191)
   $Label1 = GUICtrlCreateLabel("Exit tool", 32, 27, 41, 17)
   $exitcombo = GUICtrlCreateCombo("", 72, 24, 80, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
   guictrlsetdata($exitcombo,$poshotkeys,$hotkey[1])
   $Label2 = GUICtrlCreateLabel("stop", 40, 91, 32, 17)
   $stopcombo = GUICtrlCreateCombo("", 72, 88, 80, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
   guictrlsetdata($stopcombo,$poshotkeys,$hotkey[2])
   $okbutton = GUICtrlCreateButton("Ok", 8, 144, 75, 25)
   $cancelbutton = GUICtrlCreateButton("Cancel", 112, 144, 75, 25)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   While 1
	  $nMsg = GUIGetMsg()
	  Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			ExitLoop
         case $okbutton
			HotKeySet($hotkey[1])
			hotkeyset($hotkey[2])
			$hotkey[1] = guictrlread($exitcombo)
			$hotkey[2] = guictrlread($stopcombo)
			hotkeyset($hotkey[1],"_exit")
			hotkeyset($hotkey[2],"stop")
			iniwrite($config,"GENERAL","hotkey",$hotkey[1] & "," & $hotkey[2])
			exitloop
		 case $cancelbutton
			ExitLoop
	  EndSwitch
   WEnd
   guidelete($Form3)
EndFunc

func mainguiloop(); main gui loop for data
   guictrlsetdata($Labelready2,"No")
   GUICtrlSetColor($Labelready2,"0xFF0000")
   guictrlsetcolor($Labelstatus2,"0xFF0000")
   GUICtrlSetData($initbutton,"Initialize")
   GUICtrlSetData($Labelstatus2,"Not Initialized")
   $spin = 0
   $useinternal = 0
   While 1
   $nMsg = GUIGetMsg()
   Select
	  Case $nMsg = $GUI_EVENT_CLOSE
		 _exit()
	  case $nMsg = $relaxbox or $nMsg = $aimccbox or $nMsg =  $aimbotbox or $nMsg = $relaxccbox or $nMsg = $relaxbotbox or $nMsg = $spinrad
		 $mode = $nMsg - $relaxbox + 1
		 GUICtrlSetData($search,$mode)
	  case $nMsg >= $listdiff[1][1] and $nMsg <= $listdiff[ubound($listdiff)-1][1]
		 $diffselected = $nMsg - $listdiff[1][1] + 1
	  case $nMsg = $search
		 $songs = search($loc,GUICtrlRead($search))
		 ;_ArrayDisplay($songs)
		 if IsArray($songs) Then listsongs($songs)
	  case $nMsg >= $listsongs[2] and $nMsg <= $listsongs[ubound($listsongs)-1]
		 listdiff($nMsg,$songs)
		 $diffselected = ""
	  case $nMsg = $updatebutton
		 $songs = search($loc,GUICtrlRead($search))
		 if IsArray($songs) Then listsongs($songs)
	  case $nMsg = $initbutton
		 while 1
		 if guictrlread($Labelready2) = "Yes" Then
		 GUICtrlSetData($Labelstatus2,"Waiting for song to be played")
		 guictrlsetcolor($Labelstatus2,"0x00FF00")
		 GUICtrlSetData($initbutton,"Stop")
			while 1
			   DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[4], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	           $ms = DllStructGetData($buffer,1)
			   if $ms <= 1000 then
				  while 1
					 DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[4], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	                 if DllStructGetData($buffer,1) < $notes[1][3][1] then ExitLoop
						consolewrite(DllStructGetData($buffer,1))
				  WEnd
				  ExitLoop
			   EndIf
			   if $exit = 1 Then
			   ExitLoop
			   EndIf
			   sleep(1)
			WEnd
		 if guictrlread($spinbox) = $GUI_CHECKED then $spin = 1
		 if $exit = 1 then exitloop
		 if $mode = 1 then relax($notes,$spinners)
		 if $mode = 3 then aimbot($notes,$spinners)
		 if $mode = 2 then aimcorrection($notes,$spinners)
		 if $mode = 4 then relaxcorrection($notes,$spinners)
		 if $mode = 5 then relaxaimbot($notes,$spinners)
		 if $mode = 6 then autospin($spinners)
		 $useinternal = 0
		 $spin = 0
		 else
			msgbox(0,"Error","Song not loaded")
			exitloop
		 EndIf
		 exitloop
	     WEnd
	     ;guictrlsetdata($Labelready2,"No")
         ;GUICtrlSetColor($Labelready2,"0xFF0000")
         guictrlsetcolor($Labelstatus2,"0xFF0000")
         GUICtrlSetData($initbutton,"Initialize")
         GUICtrlSetData($Labelstatus2,"Not Initialized")
		 $exit = 0
	  case $nMsg = $loadbutton
		 if $diffselected = "" Then
			msgbox(0,"Error","Choose a difficulty")
		 Else
		 guictrlsetdata($Labelready2,"No")
		 GUICtrlSetColor($Labelready2,"0xFF0000")
		 if guictrlread($hrbox) = $GUI_CHECKED then
			$hardrock = 1
		 Else
			$hardrock = 0
		 EndIf
		 $songfile = $listdiff[$diffselected][2]
		 $version = getversion()
		 $difficulty = getdiff()
		 $timingpoints = gettimingpoints()
		 $points = getpoints($timingpoints)
		 $redpoints = getcolorpoints($points,1)
		 $greenpoints = getcolorpoints($points,2)
		 $bpm = calcbpm($difficulty,$redpoints,$greenpoints)
		 $hitobjects = gethitobjects($version)
		 $notes = setnotesparam($hitobjects,$version,$difficulty,$bpm)
		 ;$coords = getextendedcoords($notes)
		 $spinners = getspinners($notes)
		 guictrlsetdata($Labelready2,"Yes")
		 GUICtrlSetColor($Labelready2,"0x00FF00")
		 EndIf
	  case $nMsg = $optionstab
		 GUISetState(@SW_HIDE,$Form1)
		 optionsgui()
		 guictrlsetdata($Labelready2,"No")
		 GUICtrlSetColor($Labelready2,"0xFF0000")
		 guictrlsetcolor($Labelstatus2,"0xFF0000")
		 GUICtrlSetData($initbutton,"Initialize")
		 GUICtrlSetData($Labelstatus2,"Not Initialized")
         guisetstate(@SW_SHOW,$Form1)
	  case $nMsg = $securitytab
		 $windowname = inputbox("","Enter your desired Window Name: ",$windowname)
		 if @error Then
		 Else
			iniwrite($config,"GENERAL","windowname",$windowname)
		    _exit()
		 EndIf
	  case $nMsg = $hotkeystab
		 hotkeysgui()
   EndSelect
   WEnd
EndFunc

func buttonpressed($hWnd, $Msg, $wParam, $lParam);detects if stop button is pressed
   if guictrlread($Labelstatus2) = "Waiting for song to be played" then
      if $wParam = $initbutton then
	     stop()
	  EndIf
   EndIf
EndFunc