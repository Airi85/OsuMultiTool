func optionsgui();create the GUI of options
   #Region ### START Koda GUI section ### Form=
   $Form2 = GUICreate($windowname, 1017, 365, 192, 124)
   $Tab1 = GUICtrlCreateTab(0, 0, 1017, 337)
   ;$TabSheet1 = GUICtrlCreateTabItem("General")
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
   $TabSheet4 = GUICtrlCreateTabItem("Aimbot")
   ;GUICtrlSetState(-1,$GUI_SHOW)
   $Label17 = GUICtrlCreateLabel("Time to move mouse - (x miliseconds before the note appear it will start moving the mouse)", 32, 32, 427, 17)
   $movetimein = GUICtrlCreateInput($movetime, 24, 56, 89, 21)
   $Label18 = GUICtrlCreateLabel("Miliseconds", 112, 59, 59, 17)
   $Label24 = GUICtrlCreateLabel("Slider Speed multiplier - (multiplier for slider speed, 0.95 will do but some 3+way sliders may have desync)", 32, 112, 493, 17)
   $sliderspdcorrectionin = GUICtrlCreateInput($sliderspdcorrection, 24, 136, 121, 21)
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
   $TabSheet6 = GUICtrlCreateTabItem("Performance")
   $Label32 = guictrlcreateLabel("Scan Precision - (the lower the value, the slower it is but its less likely to get error 12)",32,32,333,17)
   $scanprecisionin = guictrlcreateinput($scanprecision,24,59,73,21)
   $Label33 = GUICtrlCreateLabel("Slider Lenght Precision - (the lower the value, the slower it is but gives more precise slider timing, decrease it if you dont care about load time(or increase if you have a old processor))",32,112,700,17)
   $bezierprecisionin = guictrlcreateinput($bezierprecision,24,139,73,21)
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
			$movetime = number(guictrlread($movetimein))
			$correctionradius =  number(guictrlread($correctionradiusin))
			$accmin =  number(guictrlread($accminin))
			$accmax =  number(guictrlread($accmaxin))
			$holdmin =  number(guictrlread($holdminin))
			$holdmax =  number(guictrlread($holdmaxin))
			$maxinterval =  number(guictrlread($maxintervalin))
			$sliderspdcorrection =  number(guictrlread($sliderspdcorrectionin),3)
			$key[1] = guictrlread($key1in)
			$key[2] = guictrlread($key2in)
			$spinlinemin = number(guictrlread($spinlineminin),3)
			$spinlinemax = number(guictrlread($spinlinemaxin),3)
			$spinvariation = number(guictrlread($spinvariationin),3)
			$spinsps = number(guictrlread($spinspsin),3)
			$scanprecision = number(guictrlread($scanprecisionin))
			$bezierprecision = number(guictrlread($bezierprecisionin),3)
			if guictrlread($mousebox) = $GUI_CHECKED then
			   $usemouse = 1
		    Else
			   $usemouse = 0
			EndIf
			if $scanprecision < 4 Then
			   error(24)
			   ExitLoop
			EndIf
			if $bezierprecision > 1 or $bezierprecision < 0 or (1*$bezierprecision) = 0 then
			   msgbox(0,"",$bezierprecision & @CRLF & (1*$bezierprecision))
			   error(25)
			   ExitLoop
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
			iniwrite($config,"Performance","scanprecision",$scanprecision)
			iniwrite($config,"Performance","bezierprecision",$bezierprecision)
			exitloop
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
		 guictrlsetdata($Labelready2,"0")
		 GUICtrlSetColor($Labelready2,"0xFF00FF")
		 if guictrlread($hrbox) = $GUI_CHECKED then
			$hardrock = 1
		 Else
			$hardrock = 0
		 EndIf
		 $songfile = $listdiff[$diffselected][2]
		 $version = getversion()
		 $difficulty = getdiff()
		 guictrlsetdata($Labelready2,2.5 & "%")
		 $timingpoints = gettimingpoints()
		 $points = getpoints($timingpoints)
		 guictrlsetdata($Labelready2,5 & "%")
		 $redpoints = getcolorpoints($points,1)
		 $greenpoints = getcolorpoints($points,2)
		 guictrlsetdata($Labelready2,7.5 & "%")
		 $bpm = calcbpm($difficulty,$redpoints,$greenpoints)
		 guictrlsetdata($Labelready2,10 & "%")
		 $hitobjects = gethitobjects($version)
		 guictrlsetdata($Labelready2,50 & "%")
		 $notes = setnotesparam($hitobjects,$version,$difficulty,$bpm)
		 guictrlsetdata($Labelready2,90 & "%")
		 setnotestacking($notes)
		 ;$coords = getextendedcoords($notes)
		 $spinners = getspinners($notes)
		 guictrlsetdata($Labelready2,100 & "%")
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