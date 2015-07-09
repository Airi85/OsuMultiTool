func relax($notes,$spinners)
   GUICtrlSetData($Labelstatus2,"Running Relax")
   $i = 1
   $exit = 0
   $k = 1
   $limit = $notes[$i][3][1] + 1000
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[1], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	  $ms = DllStructGetData($buffer,1)
	  if $ms >= $notes[$i][3][1] and $ms <= $limit Then
		 if $usemouse = 1 Then
		    mousedown($notes[$i][0][2])
	     Else
		    ;dllcall($_COMMON_USER32DLL,"int","keybd_event","int",$notes[$i][0][3],"int",0,"long",0,"long",0)
			send("{" & $notes[$i][0][3] & " down}")
		 EndIf
		 if $spin = 1 Then
		 if $notes[$i][0][1] = "spinner" Then
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
		    spin($spinners[$k][4])
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
			$k += 1
		 EndIf
		 EndIf
		 while 1
			DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
			if dllstructgetdata($buffer,1) >= $notes[$i][3][2] then ExitLoop
		 WEnd
		 if $usemouse = 1 Then
		    mouseup($notes[$i][0][2])
		 Else
			;dllcall($_COMMON_USER32DLL,"int","keybd_event","int",$notes[$i][0][3],"int",0,"long",2,"long",0)
			send("{" & $notes[$i][0][3] & " up}")
		 EndIf
		 $i +=1
		 if $i > $notes[0][0][0] then return 1
		 if $exit = 1 then return 1
		 $limit = $notes[$i][3][1] + 1000
	  EndIf
   WEnd
EndFunc

func aimbot($notes,$spinners)
   GUICtrlSetData($Labelstatus2,"Running Aimbot")
   $i = 1
   $j = 2
   $k = 1
   ;$speed = $bpm[1][2]
   $limit = $notes[$i][3][1] + 1000
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	  $ms = DllStructGetData($buffer,1)
	  if $ms < $limit Then
	  if $ms >= $notes[$i][3][1] - $movetime Then
		 smoothmove($notes,$i,$ms)
	  EndIf
	  if $ms >= $notes[$i][3][1] Then
		 mousemove($notes[$i][1][1],$notes[$i][2][1],0)
		 if $notes[$i][1][0] > 1 Then
			slidermove($i,$notes,$ms)
		 EndIf
		 if $spin = 1 Then
		 if $notes[$i][0][1] = "spinner" Then
		    spin($spinners[$k][4])
			$k += 1
		 EndIf
		 EndIf
		 $i +=1
		 if $i > $notes[0][0][0] then return 1
		 if $exit = 1 then return 1
		 $limit = $notes[$i][3][1] + 1000
	  EndIf
      EndIf
   WEnd
EndFunc

func aimcorrection($notes,$spinners)
   $i = 1
   $k = 1
   $limit = $notes[$i][3][1] + 1000
   $diameter = getnotediameter()
   $radius = $diameter / 2
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	  $ms = DllStructGetData($buffer,1)
	  if $ms < $limit Then
	  if $ms >= $notes[$i][3][1] Then
		 $mousepos = mouseGetPos()
		 $diffx = $notes[$i][1][1] - $mousepos[0]
		 $diffy = $notes[$i][2][1] - $mousepos[1]
		 $linelenght = sqrt(($diffx^2) + ($diffy^2))
		 if $linelenght >= $radius Then
		    if $linelenght <= $correctionradius Then
               $diffx /= 2
		       $diffy /= 2
		       mousemove($mousepos[0] + $diffx,$mousepos[1] + $diffy,0)
		    EndIf
		 EndIf
		 if $spin = 1 Then
		 if $notes[$i][0][1] = "spinner" Then
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
		    spin($spinners[$k][4])
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
			$k += 1
		 EndIf
		 EndIf
		 $i+=1
		 if $i > $notes[0][0][0] then return 1
		 if $exit = 1 then return 1
		 $limit = $notes[$i][3][1] + 1000
	  EndIf
      EndIf
   WEnd
EndFunc

func relaxcorrection($notes,$spinners)
   $i = 1
   $k = 1
   $limit = $notes[$i][3][1] + 1000
   $diameter = getnotediameter()
   $radius = ($diameter / 2) * 0.80
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	  $ms = DllStructGetData($buffer,1)
	  if $ms < $limit Then
	  if $ms >= $notes[$i][3][1] Then
		 $mousepos = mouseGetPos()
		 $diffx = $notes[$i][1][1] - $mousepos[0]
		 $diffy = $notes[$i][2][1] - $mousepos[1]
		 $linelenght = sqrt(($diffx^2) + ($diffy^2))
		 if $linelenght >= $radius Then
		    if $linelenght <= $correctionradius + $radius Then
               $diffx /= 2
		       $diffy /= 2
		       mousemove($mousepos[0] + $diffx,$mousepos[1] + $diffy,0)
		    EndIf
		 EndIf
		 if $usemouse = 1 Then
		    mousedown($notes[$i][0][2])
	     Else
		    send("{" & $notes[$i][0][3] & " down}")
		 EndIf
		 if $spin = 1 Then
		 if $notes[$i][0][1] = "spinner" Then
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
		    spin($spinners[$k][4])
			mousemove($notes[$i][1][1],$notes[$i][2][1],0)
			$k += 1
		 EndIf
		 EndIf
		 while 1
			DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
			if DllStructGetData($buffer,1) >= $notes[$i][3][2] then exitloop
		 WEnd
		 if $usemouse = 1 Then
		    mouseup($notes[$i][0][2])
		 Else
			send("{" & $notes[$i][0][3] & " up}")
		 EndIf
		 $i +=1
		 if $i > $notes[0][0][0] Then return -1
		 if $exit = 1 then return 1
		 $limit = $notes[$i][3][1] + 1000
	  EndIf
	  EndIf
   WEnd
EndFunc

func relaxaimbot($notes,$spinners)
   $i = 1
   $j = 2
   $k = 1
   $l = 1
   $limit = $notes[$i][3][1] + 1000
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	  $ms = DllStructGetData($buffer,1)
	  consolewrite($ms & @CRLF)
	  if $ms < $limit Then
	  if $ms >= $notes[$i][3][1] - $movetime Then
		 smoothmove($notes,$i,$ms)
	  EndIf
	  if $ms >= $notes[$i][3][1] Then
		 mousemove($notes[$i][1][1],$notes[$i][2][1],0)
		 if $usemouse = 1 Then
		    mousedown($notes[$i][0][2])
	     Else
		    send("{" & $notes[$i][0][3] & " down}")
		 EndIf
		 if $notes[$i][1][0] > 1 Then
			slidermove($i,$notes,$ms)
		 EndIf
		 if $spin = 1 Then
		 if $notes[$i][0][1] = "spinner" Then
		    spin($spinners[$l][4])
			$l += 1
		 EndIf
		 EndIf
		 while 1
			DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
			if DllStructGetData($buffer,1) >= $notes[$k][3][2] then exitloop
		 WEnd
		 if $usemouse = 1 Then
		    mouseup($notes[$i][0][2])
		 Else
			send("{" & $notes[$i][0][3] & " up}")
		 EndIf
		 $k +=1
		 $i +=1
		 if $i > $notes[0][0][0] then return 1
		 if $exit = 1 then return 1
		 $limit = $notes[$i][3][1] + 1000
	  EndIf
      EndIf
   WEnd
EndFunc

func autospin($spinners)
   $i = 1
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
      $ms = DllStructGetData($buffer,1)
	  if $ms >= $spinners[$i][3] Then
		 mousemove($spinners[$i][1],$spinners[$i][2],0)
		 if $usemouse = 1 Then
			mousedown("left")
		 Else
			send("{" & $key[1] & " down}")
		 EndIf
		 spin($spinners[$i][4])
		 if $usemouse = 1 Then
			MouseUp("left")
		 Else
			send("{" & $key[1] & " up}")
		 EndIf
		 $i += 1
		 if $i > $spinners[0][0] then return 1
	  EndIf
	  if $exit = 1 then return 1
   WEnd
EndFunc


func spin($exittime)
   dim $currcoord[3]
   $maxspindiff = 10
   $currcoord[1] = mousegetpos(0)
   $currcoord[2] = MouseGetPos(1)
   $spinline = random($spinlinemin,$spinlinemax)
   $csleep = (10000000 / $spinsps) / 40
   $ntdll = dllopen("ntdll.dll")
   $convert = 0.0174532925199433
   while 1
	  for $i = 10 to 360 step 10
		 $ptime = timerinit()
		 $cos = cos($i * $convert) * $spinline
         $sin = sin($i * $convert) * $spinline
		 $spinline = random($spinline-$spinvariation,$spinline+$spinvariation)
	     if $spinline > 100 then $spinline = 100
	     if $spinline < 50 then $spinline = 50
		 mousemove($currcoord[1]+$cos,$currcoord[2]+$sin,0)
		 DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
		 if DllStructGetData($buffer,1) >= $exittime Then return 1
		 $sleep = timerdiff($ptime) - $csleep
		 dllcall($ntdll,"dword","NtDelayExecution","int",0,"int64*",$sleep)
	  Next
   WEnd
EndFunc