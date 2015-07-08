func smoothmove($coords,$j,$firstms);make mouse move to the note, acceleration and alt point not working, was meant to do a circular movement(idk whats wrong in the math still testing)
   dim $currcoord[3]
   dim $diff[3]
   dim $pixelsptms[3]
   if $j > 1 Then
	  if mod($coords[$j-1][7][1],2) = 0 Then
		 $currcoord[1] = $coords[$j-1][1][1]
         $currcoord[2] = $coords[$j-1][2][1]
	  Else
         $currcoord[1] = $coords[$j-1][1][$coords[$j-1][1][0]]
         $currcoord[2] = $coords[$j-1][2][$coords[$j-1][2][0]]
      EndIf
   Else
	  $currcoord[1] = mousegetpos(0)
	  $currcoord[2] = mousegetpos(1)
   EndIf
   if $coords[$j][1][1] = $currcoord[1] then
      if $coords[$j][2][1] = $currcoord[2] then return 1
   EndIf
   if $coords[$j][3][1] <= $firstms then return 1
   $diff[1] = $coords[$j][1][1] - $currcoord[1]
   $diff[2] = $coords[$j][2][1] - $currcoord[2]
   $pixelsptms[1] = ($diff[1] / ($coords[$j][3][1]-$firstms)) * 12
   $pixelsptms[2] = ($diff[2] / ($coords[$j][3][1]-$firstms)) * 12
   dim $ready[5]
   $ready[1] = 2
   $ready[2] = 3
   $ready[3] = 2
   $ready[4] = 3
   $firstms += 12
   $count = 0
   while 1
	  DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
      $ms = DllStructGetData($buffer,1)
	  if $ms >= $coords[$j][3][1] Then return 1
	  if $pixelsptms[1] < 0 Then
		 if $currcoord[1] <= $coords[$j][1][1] Then
			$currcoord[1] = $coords[$j][1][1]
			$ready[3] = 1
			$pixelsptms[1] = 0
		 EndIf
	  Else
		 if $currcoord[1] >= $coords[$j][1][1] Then
			$currcoord[1] = $coords[$j][1][1]
			$ready[3] = 1
			$pixelsptms[1] = 0
		 EndIf
	  EndIf
	  if $pixelsptms[2] < 0 then
		 if $currcoord[2] <= $coords[$j][2][1] Then
			$currcoord[2] = $coords[$j][2][1]
			$ready[4] = 1
			$pixelsptms[2] = 0
		 EndIf
	  Else
		 if $currcoord[2] >= $coords[$j][2][1] Then
			$currcoord[2] = $coords[$j][2][1]
			$ready[4] = 1
			$pixelsptms[2] = 0
		 EndIf
	  EndIf
	  if $ready[3] = $ready[4] Then return -1
	  if $ms >= $firstms Then
		 $currcoord[1] += $pixelsptms[1] ;+ $acceleration[1]
		 $currcoord[2] += $pixelsptms[2] ;+ $acceleration[2]
		 $firstms += 12
		 mousemove($currcoord[1],$currcoord[2],0)
	  EndIf
   WEnd
EndFunc

func calcbpm($diff,$red,$green);calculates the final bpm in every point
   dim $tempbpm[$red[0][0] + $green[0][0] + 1][4]
   $sliderbasemult = 1
   $j = 1
   $k = 1
   if $green[0][0] = 0 then
	  redim $green[2][3]
	  $green[1][1] = 1000000
   EndIf
   for $i = 1 to $red[0][0] + $green[0][0]
   If $red[$j][1] > $green[$k][1] Then
	  $tempbpm[$i][1] = $green[$k][1] - 10
	  $tempbpm[$i][2] = $red[$j-1][2] / $green[$k][2]
	  $tempbpm[$i][3] = 2
	  $k += 1
   ElseIf $green[$k][1] >= $red[$j][1] Then
	  $tempbpm[$i][1] = $red[$j][1] - 10
	  $tempbpm[$i][2] = $red[$j][2] * $sliderbasemult
	  $tempbpm[$i][3] = 1
	  $j += 1
   Else
	  error(15)
   EndIf
   if $j > $red[0][0] then
	  for $l = $i+1 to $red[0][0] + $green[0][0]
		 $tempbpm[$l][1] = $green[$k][1] - 10
		 $tempbpm[$l][2] = $red[$j-1][2] / $green[$k][2]
	     $tempbpm[$l][3] = 2
		 $k += 1
	  Next
	  exitloop
   ElseIf $k > $green[0][0] Then
	  for $l = $i+1 to $green[0][0] + $red[0][0]
		 $tempbpm[$l][1] = $red[$j][1] - 10
	     $tempbpm[$l][2] = $red[$j][2] * $sliderbasemult
	     $tempbpm[$l][3] = 1
	     $j += 1
	  Next
	  exitloop
   EndIf
   Next
   $m = 2
   dim $finalbpm[$m][4]
   $finalbpm[1][1] =  $tempbpm[1][1]
   $finalbpm[1][2] = $tempbpm[1][2]
   $finalbpm[1][3] = $tempbpm[1][3]
   for $i = 1 to $green[0][0] + $red[0][0] - 1
	  if $tempbpm[$i][2] = $tempbpm[$i+1][2] then

	  Else
		 redim $finalbpm[$m+1][4]
		 $finalbpm[$m][1] = $tempbpm[$i+1][1]
		 $finalbpm[$m][2] = $tempbpm[$i+1][2]
		 $finalbpm[$m][3] = $tempbpm[$i+1][3]
		 $m += 1
	  EndIf
   Next
   $finalbpm[0][0] = $m-1
   ;_ArrayDisplay($finalbpm)
   return $finalbpm
EndFunc

func getspinners($notes)
   $k = 1
   dim $spinners[1][5]
   for $i = 1 to $notes[0][0][0]
	  if $notes[$i][0][1] = "spinner" Then
		 redim $spinners[$k+1][5]
		 $spinners[$k][1] = $notes[$i][1][1]
		 $spinners[$k][2] = $notes[$i][2][1]
		 $spinners[$k][3] = $notes[$i][3][1]
		 $spinners[$k][4] = $notes[$i][6][1]
		 $k += 1
	  EndIf
   Next
   $spinners[0][0] = ubound($spinners)-1
   return $spinners
EndFunc

func getextendedcoords($notes)
   local $ext[$notes[0][0][0]+1][3][2]
   local $basecoord[3]
   $curhigh = 2
   $j = 1
   for $i = 1 to $notes[0][0][0]
	  if $notes[$i][0][1] = "slider" Then
		 $tmoves = floor($notes[$i][3][3] / 10)
		 if $tmoves >= $curhigh then
			redim $ext[$notes[0][0][0]+1][3][$tmoves+1]
			$curhigh = $tmoves+1
		 EndIf
		 if $notes[$i][6][1] = "B" then
			$nmoves = 1 / $tmoves
			local $basepoints[$notes[$i][1][0]][3]
			for $j = 0 to $notes[$i][1][0]-1
			   ;msgbox(0,"",$i & @CRLF & $notes[$i][1][0] & @CRLF & $j)
			   $basepoints[$j][1] = $notes[$i][1][$j+1]
			   $basepoints[$j][2] = $notes[$i][2][$j+1]
			Next
			$n = 0
			for $j = 0 to 1-$nmoves step $nmoves
			   $n += 1
			   $ext[$i][1][$n] = getBcurvepoint($basepoints,$notes[$i][1][0]-1,$j)
			Next
	     elseif $notes[$i][6][1] = "P" Then
			$nmoves = 1 / $tmoves
			local $basepoints[$notes[$i][1][0]+1][3]
			for $j = 1 to $notes[$i][1][0]
			   $basepoints[$j][1] = $notes[$i][1][$j]
			   $basepoints[$j][2] = $notes[$i][2][$j]
			Next
			$n = 0
			for $j = 0 to 1-$nmoves step $nmoves
			   $n += 1
			   $ext[$i][1][$n] = getPcircle($basepoints,$j)
			Next
		 ;if $notes[$i][6][1] = "L" Then
		 Else
			$nmoves = floor($tmoves / $notes[$i][7][1])
			$moves = floor($nmoves / ($notes[$i][1][0] - 1))
			$in = 0
			$basecoord[1] = $notes[$i][1][1]
			$basecoord[2] = $notes[$i][2][1]
			for $k = 2 to $notes[$i][1][0]
			   for $j = $in + 1 to $moves + $in
				  ;msgbox(0,"",$j & @CRLF & $tmoves & @CRLF & $nmoves & @CRLF & $moves & @CRLF & ubound($ext,1) & @CRLF & $i & @CRLF & ubound($ext,3))
				  $ext[$i][1][$j] = $basecoord[1] + ((($notes[$i][1][$k] - $basecoord[1]) / $moves) *($j-$in))
				  $ext[$i][2][$j] = $basecoord[2] + ((($notes[$i][2][$k] - $basecoord[2]) / $moves) *($j-$in))
			   Next
			   $ext[$i][1][$moves+$in] = $notes[$i][1][$k]
			   $ext[$i][2][$moves+$in] = $notes[$i][2][$k]
			   $basecoord[1] = $notes[$i][1][$k]
			   $basecoord[2] = $notes[$i][2][$k]
			   $in += $moves
			Next
			$in = 0
			if $notes[$i][7][1] > 1 Then
			   for $r = 1 to $notes[$i][7][1]
			      for $k = 2 to $notes[$i][1][0]
			         for $j = ($nmoves*$r) + $in + 1 to ($nmoves*$r) + $moves + $in
				        $ext[$i][1][$j] = $ext[$i][1][$j-(($j-($nmoves*$r))*2)]
				        $ext[$i][2][$j] = $ext[$i][2][$j-(($j-($nmoves*$r))*2)]
			         Next
			         $in += $moves
			      Next
			   Next
			EndIf
			$ext[$i][1][0] = $tmoves
			$ext[$i][2][0] = $tmoves
		 EndIf
	  EndIf
   Next
   $ext[0][0][0] = $notes[0][0][0]
   return $ext
EndFunc

func altslidermove($j,$extended,$firstms)
   $firstms += 10
   for $i = 1 to $extended[$j][1][0]
	  while 1
	     DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	     $ms = DllStructGetData($buffer,1)
		 if $ms >= $firstms Then ExitLoop
	  WEnd
	  mousemove($extended[$j][1][$i],$extended[$j][2][$i],0)
	  consolewrite($i & @CRLF)
	  $firstms += 10
   Next
EndFunc

func slidermove($i,$notes,$firstms)
   ;$firstms += 10
   $firstms = $notes[$i][3][1]
   $moves = floor(($notes[$i][3][3] / $notes[$i][7][1]) / 10)
   $nmoves = (1 / $moves)
   $start = 0
   $end = 1
   $neg = 1
   $kstart = 0
   $kend = $notes[$i][4][0]
   for $r = 1 to $notes[$i][7][1]
   for $k = $kstart to $kend step $neg
	  if $notes[$i][4][0] = 0 Then
	     $moves = floor((($notes[$i][3][$k+3] / $sliderspdcorrection)/ $notes[$i][7][1]) / 10)
	  Else
		 $moves = floor((($notes[$i][3][$k+4] / $sliderspdcorrection) / $notes[$i][7][1]) / 10)
	  EndIf
      $nmoves = (1 / $moves) * $neg
	  if $k = $notes[$i][4][0] Then
		 $sliderend = $notes[$i][1][0]
	  Else
		 $sliderend = $notes[$i][4][$k+1]
	  EndIf
      if $k = 0 Then
		 $sliderstart = 1
	  Else
		 $sliderstart = $notes[$i][4][$k]
	  EndIf
	  consolewrite("slider: " & $notes[$i][6][1] & @CRLF & "sliderstart: " & $sliderstart & @CRLF & "sliderend: " & $sliderend & @CRLF)
   if $notes[$i][6][$sliderstart] = "B" or $notes[$i][6][$sliderstart] = "L" or $notes[$i][6][$sliderstart] = "PL" or $notes[$i][6][$sliderstart] = "C" then
	  local $basepoints[$sliderend - $sliderstart + 1][3]
	  for $j = 0 to $sliderend - $sliderstart
		 $basepoints[$j][1] = $notes[$i][1][$j+$sliderstart]
		 $basepoints[$j][2] = $notes[$i][2][$j+$sliderstart]
	  Next
	  $sadd = $nmoves
		 for $t = $start + $sadd to $end step $sadd
	     while 1
		    DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
	        if DllStructGetData($buffer,1) >= $firstms then
		      ; $tomove = getBcurvepoint($basepoints,$notes[$i][1][0]-1,$t)
			   consolewrite("bt: " & $t & @CRLF)
		       $tomove = _Bezier_GetPoint($basepoints,$t)
			   ;msgbox(0,"",$t & @CRLF & $tomove[1] & @CRLF & $tomove[2])
		       mousemove($tomove[1],$tomove[2],0)
			   $firstms += 10
			   ExitLoop
			EndIf
		 WEnd
		 Next
   Elseif $notes[$i][6][$sliderstart] = "P" Then
      local $basepoints[4][3]
      for $j = 1 to 3
		 $basepoints[$j][1] = $notes[$i][1][$j+$sliderstart-1]
		 $basepoints[$j][2] = $notes[$i][2][$j+$sliderstart-1]
	  Next
	  ;$tomove = getPcircle($basepoints,$moves)
	  $sadd = 1 / $moves * $neg
	     for $j = $start+$sadd to $end step $sadd
	        while 1
		       DllCall($osumap[0], 'int', 'ReadProcessMemory', 'int', $osumap[1], 'int', $address[2], 'ptr', $bufferptr, 'int', $buffersize, 'int', '')
		       $ms = DllStructGetData($buffer,1)
			   if $i < $notes[0][0][0] Then
			      if $ms >= $notes[$i+1][3][1] then return 1
			   EndIf
			   if $ms >= $firstms Then
				  $tomove = getPcircle($basepoints,$j)
			      mousemove($tomove[1][1],$tomove[1][2],0)
			      $firstms += 10
			      ExitLoop
		       EndIf
	        WEnd
	     Next
   EndIf
   Next
   $scont = $start
   $start = $end
   $end = $scont
   $neg *= -1
   $kcont = $kstart
   $kstart = $kend
   $kend = $kcont
   Next
EndFunc

Func _Bezier_GetPoint($B, $t)
    Local $n = UBound($B) - 1
    For $k = 1 To $n
        For $i = 0 To $n - $k
            $B[$i][1] = (1 - $t) * $B[$i][1] + $t * $B[$i + 1][1]
            $B[$i][2] = (1 - $t) * $B[$i][2] + $t * $B[$i + 1][2]
        Next
    Next
    Local $ret[3]
    $ret[1] = $B[0][1]
    $ret[2] = $B[0][2]
    Return $ret
EndFunc

func getBcurvepoint($basepoints,$n,$t)
   $x = 0
   $y = 0
   for $i = 0 to $n
	  $x += bin($i,$n)*(1-$t)^($n-$i)*($t^$i)*$basepoints[$i][1]
	  $y += bin($i,$n)*(1-$t)^($n-$i)*($t^$i)*$basepoints[$i][2]
   Next
   dim $a[3]
   $a[1] = $x
   $a[2] = $y
   return $a
EndFunc

func bin($x,$y)
   if $x = 0 then return 1
   if $x = $y then return 1
   if $x > 1 Then
      for $i = $x-1 to 1 step -1
         $x *= $i
      Next
   EndIf
   if $y > 1 Then
      for $i = $y-1 to 1 step -1
	     $y *= $i
      Next
   EndIf
   $z = $y - $x
   if $z > 1 Then
	  for $i = $z to 1 step -1
		 $z *= $i
	  Next
   EndIf
   $x *= $z
   $z = $y / $x
   return $z
EndFunc

func getabsolutecoords($x,$type)
   if $type = 0 Then
	  $y = ($osuCoordX + ($x * $scale) + $marginLeft)
   elseif $type = 1 Then
	  if $hardrock = 1 Then
	     if $x > 192 then
			$x = 192 - ($x - 192)
		 Elseif $x < 192 then
			$x = 192 + (192 - $x)
		 EndIf
	  EndIf
	  $y = ($osuCoordY + ($x * $scale) + $marginTop)
   EndIf
   return $y
EndFunc

func reversecoords($x,$type)
   if $type = 0 Then
	  $y = ($x - $osuCoordX - $marginLeft) / $scale
   elseif $type = 1 Then
	  $y = ($x - $osuCoordY - $marginTop) / $scale
   EndIf
   return $y
EndFunc

func getPcircle($basepoints,$t)
   $rconvert = 57.295779513082320
   $convert = 0.0174532925199433
   local $angle[4]
   local $diffx[4]
   local $diffy[4]
   local $line[4]
   $diffx[1] = positive($basepoints[1][1] - $basepoints[2][1])
   $diffy[1] = positive($basepoints[1][2] - $basepoints[2][2])
   $diffx[2] = positive($basepoints[2][1] - $basepoints[3][1])
   $diffy[2] = positive($basepoints[2][2] - $basepoints[3][2])
   $diffx[3] = positive($basepoints[1][1] - $basepoints[3][1])
   $diffy[3] = positive($basepoints[1][2] - $basepoints[3][2])
   for $i = 1 to 3
      if $diffx[$i] = 0 Then
	     $line[$i] = $diffy[$i]
      ElseIf $diffy = 0 then
	     $line[$i] = $diffx[$i]
      Else
	     $line[$i] = sqrt(($diffx[$i]^2)+($diffy[$i]^2))
      EndIf
   Next
   $diameter = (2*$line[1]*$line[2]*$line[3]) / (sqrt(($line[1]+$line[2]+$line[3])*(($line[1]*-1)+$line[2]+$line[3])*($line[1]+($line[2]*-1)+$line[3])*($line[1]+$line[2]+($line[3]*-1))))
   $radius = $diameter/2
   $D = 2*(($basepoints[1][1]*($basepoints[2][2]-$basepoints[3][2]))+($basepoints[2][1]*($basepoints[3][2]-$basepoints[1][2]))+($basepoints[3][1]*($basepoints[1][2]-$basepoints[2][2])))
   $Xcenter = (((($basepoints[1][1]^2)+($basepoints[1][2]^2))*($basepoints[2][2]-$basepoints[3][2])) + ((($basepoints[2][1]^2)+($basepoints[2][2]^2))*($basepoints[3][2]-$basepoints[1][2])) + ((($basepoints[3][1]^2)+$basepoints[3][2]^2)*($basepoints[1][2]-$basepoints[2][2]))) / $D
   $Ycenter = (((($basepoints[1][1]^2)+($basepoints[1][2]^2))*($basepoints[3][1]-$basepoints[2][1])) + ((($basepoints[2][1]^2)+($basepoints[2][2]^2))*($basepoints[1][1]-$basepoints[3][1])) + ((($basepoints[3][1]^2)+$basepoints[3][2]^2)*($basepoints[2][1]-$basepoints[1][1]))) / $D
   for $i = 1 to 3
      $WidthLine = $basepoints[$i][1]-$Xcenter
      $HeightLine = $Ycenter-$basepoints[$i][2]
      $atan = abs(ATan($HeightLine/$WidthLine)*$rconvert)
	  $Angle[$i] = fixangle($basepoints[$i][1]-$Xcenter,$basepoints[$i][2]-$Ycenter,$atan)
   Next
   local $finalcoords[2][3]
   ;for $j = 1 to $tmoves
	  ;$t = $j * (1 / $tmoves)
	  consolewrite("t: " & $t & @CRLF)
   $adiff = $Angle[2] - $Angle[1]
   if $adiff < 0 Then $adiff = 360 - positive($adiff)
   $adiff2 = $Angle[3] - $Angle[1]
   if $adiff2 < 0 then $adiff2 = 360 - positive($adiff2)
   if positive($adiff2) > positive($adiff) Then
	  if $Angle[1] > $Angle[3] Then
		 $i = $Angle[1] + ((360-(positive($Angle[3] - $Angle[1]))) * $t)
	  Else
		 $i = $Angle[1] + ((positive($Angle[3] - $Angle[1])) * $t)
	  EndIf
   Else
	  if $Angle[1] < $Angle[3] Then
		 $i = $Angle[1] - ((360-(positive($Angle[3] - $Angle[1]))) * $t)
	  Else
		 $i = $Angle[1] - ((positive($Angle[3] - $Angle[1])) * $t)
	  EndIf
   EndIf
   if $i <= 0 then $i += 360
   if $i > 360 then $i -= 360
   $cos = cos($i * $convert) * $radius
   $sin = sin($i * $convert) * $radius
   $finalcoords[1][1] = $Xcenter + $cos
   $finalcoords[1][2] = $Ycenter + $sin
   ;Next
   return $finalcoords
EndFunc

func getbezierlenght($basepoints)
   local $currcoord[3]
   local $diff[3]
   $blenght = 0
   $currcoord[1] = $basepoints[0][1]
   $currcoord[2] = $basepoints[0][2]
   for $t = $bezierprecision to 1 step $bezierprecision
      $z = _Bezier_GetPoint($basepoints,$t)
	  ;_ArrayDisplay($z)
	  $diff[1] = positive($currcoord[1] - $z[1])
	  $diff[2] = positive($currcoord[2] - $z[2])
	  $blenght += sqrt(($diff[1]^2)+($diff[2]^2))
	  $currcoord[1] = $z[1]
	  $currcoord[2] = $z[2]
   Next
   ;msgbox(0,"e",$blenght)
   return $blenght
EndFunc

func getPlenght($basepoints)
   $rconvert = 57.295779513082320
   $pi = 3.14159265359
   local $angle[4]
   local $diffx[4]
   local $diffy[4]
   local $line[4]
   $diffx[1] = positive($basepoints[1][1] - $basepoints[2][1])
   $diffy[1] = positive($basepoints[1][2] - $basepoints[2][2])
   $diffx[2] = positive($basepoints[2][1] - $basepoints[3][1])
   $diffy[2] = positive($basepoints[2][2] - $basepoints[3][2])
   $diffx[3] = positive($basepoints[1][1] - $basepoints[3][1])
   $diffy[3] = positive($basepoints[1][2] - $basepoints[3][2])
   for $i = 1 to 3
      if $diffx[$i] = 0 Then
	     $line[$i] = $diffy[$i]
      ElseIf $diffy = 0 then
	     $line[$i] = $diffx[$i]
      Else
	     $line[$i] = sqrt(($diffx[$i]^2)+($diffy[$i]^2))
      EndIf
   Next
   $diameter = (2*$line[1]*$line[2]*$line[3]) / (sqrt(($line[1]+$line[2]+$line[3])*(($line[1]*-1)+$line[2]+$line[3])*($line[1]+($line[2]*-1)+$line[3])*($line[1]+$line[2]+($line[3]*-1))))
   $circlelenght = $pi * $diameter
   $D = 2*(($basepoints[1][1]*($basepoints[2][2]-$basepoints[3][2]))+($basepoints[2][1]*($basepoints[3][2]-$basepoints[1][2]))+($basepoints[3][1]*($basepoints[1][2]-$basepoints[2][2])))
   $Xcenter = (((($basepoints[1][1]^2)+($basepoints[1][2]^2))*($basepoints[2][2]-$basepoints[3][2])) + ((($basepoints[2][1]^2)+($basepoints[2][2]^2))*($basepoints[3][2]-$basepoints[1][2])) + ((($basepoints[3][1]^2)+$basepoints[3][2]^2)*($basepoints[1][2]-$basepoints[2][2]))) / $D
   $Ycenter = (((($basepoints[1][1]^2)+($basepoints[1][2]^2))*($basepoints[3][1]-$basepoints[2][1])) + ((($basepoints[2][1]^2)+($basepoints[2][2]^2))*($basepoints[1][1]-$basepoints[3][1])) + ((($basepoints[3][1]^2)+$basepoints[3][2]^2)*($basepoints[2][1]-$basepoints[1][1]))) / $D
   for $i = 1 to 3
      $WidthLine = $basepoints[$i][1]-$Xcenter
      $HeightLine = $Ycenter-$basepoints[$i][2]
      $atan = abs(ATan($HeightLine/$WidthLine)*$rconvert)
	  $Angle[$i] = fixangle($basepoints[$i][1]-$Xcenter,$basepoints[$i][2]-$Ycenter,$atan)
   Next
   $adiff = $Angle[2] - $Angle[1]
   if $adiff < 0 Then $adiff = 360 - positive($adiff)
   $adiff2 = $Angle[3] - $Angle[1]
   if $adiff2 < 0 then $adiff2 = 360 - positive($adiff2)
   if positive($adiff2) > positive($adiff) Then
	  if $Angle[1] > $Angle[3] Then
		 $anglediff = 360-(positive($Angle[3] - $Angle[1]))
	  Else
		 $anglediff = positive($Angle[3] - $Angle[1])
	  EndIf
   Else
	  if $Angle[1] < $Angle[3] Then
		 $anglediff = 360-(positive($Angle[3] - $Angle[1]))
	  Else
		 $anglediff = positive($Angle[3] - $Angle[1])
	  EndIf
   EndIf
   if $anglediff <= 0 then error(20)
   if $anglediff > 360 then error(20)
   $finallenght = ($circlelenght * $anglediff) / 360
   return $finallenght
EndFunc

