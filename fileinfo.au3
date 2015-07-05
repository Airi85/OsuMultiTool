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
   $filecontent = FileRead($handle)
   $filecontent = stringsplit($filecontent,"[Difficulty]",1)
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
   fileclose($handle)
   return $diff
EndFunc

func setnotesparam($hitobjects,$version,$diff,$bpm)
   local $notes[$hitobjects[0]+1][13][5]
   $keycode = getkeycodes()
   $curhigh = 5
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
		 for $j = 2 to $atemp[0]
			$notes[$i][1][$j] = getabsolutecoords(stringleft($atemp[$j],stringinstr($atemp[$j],":")-1),0)
			$notes[$i][2][$j] = getabsolutecoords(stringtrimleft($atemp[$j],stringinstr($atemp[$j],":")),1)
			;msgbox(0,"",$notes[$i][1][$j] & @CRLF & $j)
		 Next
		 $notes[$i][1][0] = $atemp[0]
		 $notes[$i][2][0] = $atemp[0]
		 $notes[$i][3][1] = $temp[3] - $acc
		 $notes[$i][3][2] = calcslidertime($bpm,$temp[3],$temp[8],$diff[5],$temp[7]) + $holdtime
		 $notes[$i][3][3] = $notes[$i][3][2] - $notes[$i][3][1]
		 $notes[$i][6][1] = $atemp[1]
		 $notes[$i][7][1] = $temp[7]
		 $notes[$i][8][1] = $temp[8]
		 if $notes[$i][1][0] = 2 and $notes[$i][6][1] = "P" then $notes[$i][6][1] = "PL"
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
	  if $i < $hitobjects[0] Then
	     if $notes[$i][3][1] + $maxinterval > $notes[$i+1][3][1] Then
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
   Next
   $notes[0][0][0] = $hitobjects[0]
   return $notes
EndFunc

