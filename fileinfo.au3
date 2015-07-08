func getversion();get the version of the .osu file
   $handle = fileopen($songfile)
   $version = filereadline($handle,1)
   $version = stringsplit($version,"v")
   fileclose($handle)
   return $version[2]
EndFunc

func gettimingpoints();get timing points(red and green points)
   $j = 1
   $handle = fileopen($songfile)
   $filecontent = FileRead($handle)
   $filecontent = stringsplit($filecontent,"[TimingPoints]",1)
   $afilecontent = stringsplit($filecontent[2],"[")
   $timingpoints = stringsplit($afilecontent[1],@CRLF)
   dim $extimingpoints[1]
   for $i = 1 to $timingpoints[0]
	  if $timingpoints[$i] = "" Then
	  Else
		 $j += 1
		 redim $extimingpoints[$j]
		 $extimingpoints[$j-1] = $timingpoints[$i]
	  EndIf
   Next
   $extimingpoints[0] = ubound($extimingpoints) - 1
   fileclose($handle)
   return $extimingpoints
EndFunc

func getpoints($timingpoints);separate red and green points
   $j = 1
   $k = 1
   dim $points[$timingpoints[0]+1][3]
   for $i = 1 to $timingpoints[0]
	  $temp = stringsplit($timingpoints[$i],",")
	  if $temp[2] < 0 Then
		 $points[$j][2] = $timingpoints[$i]
		 $j += 1
	  Elseif $temp[2] > 0 Then
	     $points[$k][1] = $timingpoints[$i]
		 $k += 1
	  Else
		 error(13)
	  EndIf
   Next
   $points[0][1] = $k - 1
   $points[0][2] = $j - 1
   return $points
EndFunc

func getcolorpoints($points,$j);apply the math to get the real value of green and red points
   dim $colorpoints[$points[0][$j]+1][3]
   for $i = 1 to $points[0][$j]
	  $temp = stringsplit($points[$i][$j],",")
	  if $temp[2] > 0 Then
		 $temp[2] = $temp[2] ;(4000/$temp[2])*15
	  elseif $temp[2] < 0 Then
		 $temp[2] = 100/(-1*$temp[2])
	  Else
		 error(14)
	  EndIf
	  $colorpoints[$i][1] = int($temp[1])
	  $colorpoints[$i][2] = $temp[2]
   Next
   $colorpoints[0][0] = $points[0][$j]
   return $colorpoints
EndFunc

func getdiff();get difficulty of the song [1] = HP  [2] = CS  [3] = OD  [4] = AR  [5] = slider speed multiplier  [6] = slider tick rate(dont influences slider speed, idk what this is used for)
   $temp = ""
   $j = 1
   $handle = fileopen($songfile)
   $filecontent0 = FileRead($handle)
   $filecontent = stringsplit($filecontent0,"[Difficulty]",1)
   $filecontent = stringsplit($filecontent[2],"[")
   $filecontent = stringsplit($filecontent[1],@CRLF)
   dim $atemp[1]
   for $i = 1 to $filecontent[0]
	  if $filecontent[$i] = "" Then
	  Else
		 $j += 1
		 redim $atemp[$j]
		 $atemp[$j-1] = $filecontent[$i]
	  EndIf
   Next
   if $version <= 7 Then
   for $i = 1 to 5
   if $i = 4 Then
	  $temp &= 0 & ","
   EndIf
   $dpos = StringInStr($atemp[$i],":")
   $temp &= stringmid($atemp[$i],$dpos+1) & ","
   Next
   Else
   for $i = 1 to 6
   $dpos = StringInStr($atemp[$i],":")
   $temp &= stringmid($atemp[$i],$dpos+1) & ","
   Next
   EndIf
   $temp = stringleft($temp,stringlen($temp)-1)
   $diff = stringsplit($temp,",")
   redim $diff[9]
   if $version <= 4 Then
	  $diff[7] = 1
   Else
	  $slloc = stringinstr($filecontent0,"StackLeniency: ")+15
	  $elloc = stringinstr($filecontent0,@CRLF,0,1,$slloc) - $slloc
      $diff[7] = stringmid($filecontent0,$slloc,$elloc)
   EndIf
   if $version <= 5 Then
	  $diff[8] = 16
   Else
	  $bdloc = stringinstr($filecontent0,"BeatDivisor: ")+13
	  $elloc = stringinstr($filecontent0,@CRLF,0,1,$bdloc) - $bdloc
      $diff[8] = stringmid($filecontent0,$bdloc,$elloc)
   EndIf
   fileclose($handle)
   return $diff
EndFunc

func setnotesparam($hitobjects,$version,$diff,$bpm)
   local $notes[$hitobjects[0]+1][13][7]
   dim $basepoints[2][3]
   $keycode = getkeycodes()
   $curhigh = 7
   for $i = 1 to $hitobjects[0]
	  $acc = int(random($accmin,$accmax))
	  $holdtime = int(random($holdmin,$holdmax))
	  $temp = stringsplit($hitobjects[$i],",")
	  redim $temp[13]
	  if stringinstr($temp[6],"|") Then
		 $notes[$i][0][1] = "slider"
		 $atemp = stringsplit($temp[6],"|")
		 $temp[6] = $atemp[1]
		 ;_ArrayDisplay($atemp)
		 if $atemp[0] >= $curhigh Then
			redim $notes[$hitobjects[0]+1][13][$atemp[0]+1]
			$curhigh = $atemp[0]+1
		 EndIf
		 $notes[$i][1][1] = getabsolutecoords($temp[1],0)
		 $notes[$i][2][1] = getabsolutecoords($temp[2],1)
		 $k = 1
		 $red = 0
		 $l = 0
		 for $j = 2 to $atemp[0]
			if $atemp[$j] <> $atemp[$j-1] Then
			   $k += 1
			   $notes[$i][1][$k] = getabsolutecoords(stringleft($atemp[$j],stringinstr($atemp[$j],":")-1),0)
			   $notes[$i][2][$k] = getabsolutecoords(stringtrimleft($atemp[$j],stringinstr($atemp[$j],":")),1)
			Else
			   $red += 1
			   if $j <> $atemp[0] Then
			      $l += 1
			      $notes[$i][4][$l] = $k
			   EndIf
			EndIf
			;msgbox(0,"",$notes[$i][1][$j] & @CRLF & $j)
		 Next
		 $notes[$i][1][0] = $atemp[0] - $red
		 $notes[$i][2][0] = $atemp[0] - $red
		 $notes[$i][3][0] = $temp[3]
		 $notes[$i][3][1] = $temp[3] - $acc
		 $notes[$i][3][2] = calcslidertime($bpm,$temp[3],$temp[8],$diff[5],$temp[7]) + $holdtime
		 $notes[$i][3][3] = $notes[$i][3][2] - $notes[$i][3][1]
		 $notes[$i][4][0] = $l
		 $notes[$i][6][1] = $atemp[1]
		 $notes[$i][7][1] = $temp[7]
		 $notes[$i][8][1] = $temp[8]
		 if $notes[$i][4][0] > 0 Then
			if $notes[$i][6][1] = "P" then
			   if $notes[$i][4][1] = 2 Then
			      $notes[$i][6][1] = "PL"
				  $notes[$i][8][0] = sqrt(((reversecoords($notes[$i][1][1],0) - reversecoords($notes[$i][1][2],0))^2) + ((reversecoords($notes[$i][2][1],1) - reversecoords($notes[$i][2][2],1))^2))
			   ElseIf $notes[$i][4][1] = 3 Then
				  redim $basepoints[4][3]
				  for $h = 1 to 3
					 $basepoints[$h][1] = reversecoords($notes[$i][1][$h],0)
					 $basepoints[$h][2] = reversecoords($notes[$i][2][$h],1)
				  Next
				  $notes[$i][8][0] = getPlenght($basepoints)
			   EndIf
			ElseIf $notes[$i][6][1] = "B" Then
			   redim $basepoints[$notes[$i][4][1]][3]
			   for $h = 0 to $notes[$i][4][1]-1
				  $basepoints[$h][1] = reversecoords($notes[$i][1][$h+1],0)
				  $basepoints[$h][2] = reversecoords($notes[$i][2][$h+1],1)
			   Next
			   $notes[$i][8][0] = getbezierlenght($basepoints)
			ElseIf $notes[$i][6][1] = "L" Then
			   $notes[$i][8][0] = sqrt(((reversecoords($notes[$i][1][1],0) - reversecoords($notes[$i][1][2],0))^2) + ((reversecoords($notes[$i][2][1],1) - reversecoords($notes[$i][2][2],1))^2))
			Else
			   error(22)
			EndIf
			$notes[$i][3][4] = calcslidertime($bpm,$temp[3],$notes[$i][8][0],$diff[5],$temp[7]) - $temp[3]
			for $j = 1 to $notes[$i][4][0]
			   if $j = $notes[$i][4][0] then
			      $sliderend = $notes[$i][1][0]
			   Else
			      $sliderend = $notes[$i][4][$j+1]
			   EndIf
			   if $notes[$i][6][1] = "B" Then
				  $notes[$i][6][$notes[$i][4][$j]] = "B"
				  redim $basepoints[$sliderend - $notes[$i][4][$j] + 1][3]
				  for $h = 0 to $sliderend - $notes[$i][4][$j]
					 $basepoints[$h][1] = reversecoords($notes[$i][1][$h + $notes[$i][4][$j]],0)
					 $basepoints[$h][2] = reversecoords($notes[$i][2][$h + $notes[$i][4][$j]],1)
				  Next
				  $notes[$i][8][$notes[$i][4][$j]] = getbezierlenght($basepoints)
			   elseif $notes[$i][6][1] = "L" Then
				  $notes[$i][6][$notes[$i][4][$j]] = "L"
				  $notes[$i][8][$notes[$i][4][$j]] = sqrt(((reversecoords($notes[$i][1][$notes[$i][4][$j]],0) - reversecoords($notes[$i][1][$sliderend],0))^2) + ((reversecoords($notes[$i][2][$notes[$i][4][$j]],1) - reversecoords($notes[$i][2][$sliderend],1))^2))
			   elseif $notes[$i][6][1] = "P" or $notes[$i][6][1] = "PL" Then
				  if $j < $notes[$i][4][0] Then
					 if $notes[$i][4][$j+1] - $notes[$i][4][$j] + 1 = 2 then
						$notes[$i][6][$notes[$i][4][$j]] = "PL"
						$notes[$i][8][$notes[$i][4][$j]] = sqrt(((reversecoords($notes[$i][1][$notes[$i][4][$j]],0) - reversecoords($notes[$i][1][$sliderend],0))^2) + ((reversecoords($notes[$i][2][$notes[$i][4][$j]],1) - reversecoords($notes[$i][2][$sliderend],1))^2))
					 ElseIf $notes[$i][4][$j+1] - $notes[$i][4][$j] + 1 = 3 then
						$notes[$i][6][$notes[$i][4][$j]] = "P"
						redim $basepoints[$sliderend - $notes[$i][4][$j] + 2][3]
						for $h = 1 to $sliderend - $notes[$i][4][$j] + 1
						   $basepoints[$h][1] = reversecoords($notes[$i][1][$h + $notes[$i][4][$j]-1],0)
						   $basepoints[$h][2] = reversecoords($notes[$i][2][$h + $notes[$i][4][$j]-1],1)
						Next
						$notes[$i][8][$notes[$i][4][$j]] = getPlenght($basepoints)
					 Else
						error(21)
					 EndIf
				  Else
					 if $notes[$i][1][0] - $notes[$i][4][$j] + 1 = 2 then
						$notes[$i][6][$notes[$i][4][$j]] = "PL"
					 ElseIf $notes[$i][1][0] - $notes[$i][4][$j] + 1 = 3 then
						$notes[$i][6][$notes[$i][4][$j]] = "P"
					 Else
						error(21)
					 EndIf
				  EndIf
			   Else
				  error(22)
			   EndIf
			   $notes[$i][3][$j+4] = calcslidertime($bpm,$temp[3],$notes[$i][8][$notes[$i][4][$j]],$diff[5],$temp[7]) - $temp[3]
			   if $j = $notes[$i][4][0] Then
				  $timeunt = 0
				  for $h = 4 to $notes[$i][4][0] + 3
					 $timeunt += $notes[$i][3][$h]
				  Next
				  $notes[$i][3][$j+4] = $notes[$i][3][3] - $timeunt
				  if $notes[$i][3][$j+4] < 0 then error(23)
			   EndIf
			Next
		 Else
			if $notes[$i][1][0] = 2 and $notes[$i][6][1] = "P" then $notes[$i][6][1] = "PL"
			if $notes[$i][1][0] > 3 and $notes[$i][6][1] = "P" then error(21)
			if $notes[$i][6][1] = "C" then error(22)
		 EndIf
	  Elseif int($temp[6]) > int($temp[3]) Then
	     $notes[$i][0][1] = "spinner"
		 $notes[$i][1][1] = getabsolutecoords($temp[1],0)
		 $notes[$i][2][1] = getabsolutecoords($temp[2],1)
		 $notes[$i][3][1] = $temp[3] - $acc
		 $notes[$i][6][1] = $temp[6] + $holdtime
		 $notes[$i][1][0] = 1
		 $notes[$i][2][0] = 1
	  Else
		 $notes[$i][0][1] = "tap"
		 $notes[$i][1][1] = getabsolutecoords($temp[1],0)
		 $notes[$i][2][1] = getabsolutecoords($temp[2],1)
		 $notes[$i][3][1] = $temp[3] - $acc
		 $notes[$i][3][2] = $notes[$i][3][1] + $holdtime
		 $notes[$i][1][0] = 1
		 $notes[$i][2][0] = 1
	  EndIf
	  if $i > 1 Then
	     if positive($notes[$i][3][1] - $notes[$i-1][3][1]) < $maxinterval Then
		    if $notes[$i-1][0][2] = "left" Then
	           $notes[$i][0][2] = "right"
		       $notes[$i][0][3] = $key[2]
		    Else
			   $notes[$i][0][2] = "left"
		       $notes[$i][0][3] = $key[1]
		    EndIf
	     Else
		    $notes[$i][0][2] = "left"
		    $notes[$i][0][3] = $key[1]
	     EndIf
	  Else
		 $notes[$i][0][2] = "left"
		 $notes[$i][0][3] = $key[1]
	  EndIf
	  consolewrite($notes[$i][0][2] & @CRLF)
   Next
   $notes[0][0][0] = $hitobjects[0]
   return $notes
EndFunc

func setnotestacking(byref $notes)
   $maxstackinterval = getnotestackinglimit()
   $fs = $notes[0][0][0]
   for $i = $notes[0][0][0]-1 to 1 step -1
	  if $notes[$i][1][1] = $notes[$fs][1][1] and $notes[$i][2][1] = $notes[$fs][2][1] and $notes[$i+1][3][0] - $notes[$i][3][0] <= $maxstackinterval Then
		 $notes[$i][1][1] -= 4*($fs-$i)
		 $notes[$i][2][1] -= 4*($fs-$i)
	  Elseif $notes[$i][1][1] = $notes[$fs][1][$notes[$fs][1][0]] and $notes[$i][2][1] = $notes[$fs][2][$notes[$fs][1][0]] and $notes[$i+1][3][0] - $notes[$i][3][0] <= $maxstackinterval Then
		 $notes[$i][1][1] -= 4*($fs-$i)
		 $notes[$i][2][1] -= 4*($fs-$i)
	  Elseif $notes[$i][1][1] = $notes[$fs][1][1] and $notes[$i][2][1] = $notes[$fs][2][1] Then
	     $notes[$i][1][1] -= 4
		 $notes[$i][2][1] -= 4
		 $fs = $i
	  ElseIf $notes[$i][1][1] = $notes[$fs][1][$notes[$fs][1][0]] and $notes[$i][2][1] = $notes[$fs][2][$notes[$fs][1][0]] Then
		 $notes[$i][1][1] -= 4
		 $notes[$i][2][1] -= 4
		 $fs = $i
	  Else
	     $fs = $i
	  EndIf
   Next
EndFunc


