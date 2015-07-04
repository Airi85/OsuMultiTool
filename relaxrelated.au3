func gethitobjects($version);get all hit objects
   $handle = fileopen($songfile)
   $filecontent = FileRead($handle)
   $filecontent = stringsplit($filecontent,"[HitObjects]",1);take all content below [HitObjects] to filecontent[2]
   $hitobjects = stringsplit($filecontent[2],@CRLF);separate content from filecontent[2] every line separately in a array
   for $i = $hitobjects[0] to 1 step -1            ;\
	  if not stringinstr($hitobjects[$i],",") Then ;\
		 _Arraydelete($hitobjects,$i)              ;- delete data from the array that isn't hit objects
	  EndIf                                        ;/
   Next                                            ;/
   $hitobjects[0] = ubound($hitobjects)-1;set the max index of $hitobjects to $hitobjects[0]
   fileclose($handle)
   return $hitobjects
EndFunc

func sepobjects($version,$hitobjects);separate taps from sliders
   if $version = 14 then $spinparam = 9                    ;\
   if $version >=10 and $version <=13 then $spinparam = 7  ;- set the number of parameters in a line of a spinnner, according to version
   if $version >= 3 and $version <= 9 then $spinparam = 6  ;/
   $sliders = ""
   $taps = ""
   $spinners = ""
   $nspins = 0
   for $i = 1 to $hitobjects[0]                           ;\
	  if stringinstr($hitobjects[$i],"|") Then            ;\
		 $sliders &= $hitobjects[$i] & "separator"        ;\
	  Else                                                ;\
		 $temp = stringsplit($hitobjects[$i],",")         ;\
			if $temp[0] < 6 Then                          ;\
			   redim $temp[7]                             ;\
			   $temp[6] = 0                               ;- separate hit objects in 3 variables, spinners, sliders and taps, only sliders have
			EndIf                                         ;- '|' in its line, and taps dont have the same number of parameters of a spinner,
			if int($temp[6]) > int($temp[3]) then         ;- when they do, parameter 6 is greater than parameter 3
			   $spinners &= $hitobjects[$i] & "separator" ;/
			Else                                          ;/
			   $taps &= $hitobjects[$i] & "separator"     ;/
			EndIf			                              ;/
	  EndIf                                               ;/
   Next                                                   ;/
   dim $objects[4][$hitobjects[0]]
   $temp = stringsplit($sliders,"separator",1)  ;\
   for $i = 0 to $temp[0]-1                     ;\
	  $objects[1][$i] = $temp[$i]               ;\
   next                                         ;\
   $temp = stringsplit($taps,"separator",1)     ;\
   for $i = 0 to $temp[0]-1                     ;\
	  $objects[2][$i] = $temp[$i]               ;- put spinners, sliders and taps in a array [1][x] = sliders
   next                                         ;- [2][x] = taps  [3][x] = spinners, max index at [0][0]
   $temp = stringsplit($spinners,"separator",1) ;/
   for $i = 0 to $temp[0]-1                     ;/
	  $objects[3][$i] = $temp[$i]               ;/
   next                                         ;/
   $objects[0][0] = $hitobjects[0]              ;/
   return $objects
EndFunc

func gettimer($version,$objects);extract the timing from objects
   dim $atemp[4][$objects[0][0]+1]
   for $i = 1 to $objects[1][0]-1
	  $temptime = stringsplit($objects[1][$i],",")
	  $atemp[1][$i] = $temptime[3] & ",slider"
   Next
   for $i = 1 to $objects[2][0]-1
	  $temptime = stringsplit($objects[2][$i],",")
	  $atemp[2][$i] = $temptime[3] & ",tap"
   Next
   for $i = 1 to $objects[3][0]-1
	  $temptime = stringsplit($objects[3][$i],",")
	  $atemp[3][$i] = $temptime[3] & ",spinner-" & $temptime[6]
   Next
   $max = $objects[0][0]
   redim $objects[4][$objects[0][0]][3]
   for $ii = 1 to $max
      $temp = stringsplit($atemp[1][$ii],",")
      if not $temp[1] = "" Then
         for $i = 1 to 2
	        $objects[1][$ii][$i] = $temp[$i]
		 Next
      EndIf
   Next
   for $ii = 1 to $max
      $temp = stringsplit($atemp[2][$ii],",")
	  if not $temp[1] = "" Then
		 for $i = 1 to 2
			$objects[2][$ii][$i] = $temp[$i]
         Next
      EndIf
   Next
   for $ii = 1 to $max
      $temp = stringsplit($atemp[3][$ii],",")
      if not $temp[1] = "" Then
         for $i = 1 to 2
	        $objects[3][$ii][$i] = $temp[$i]
         Next
      EndIf
   Next
   $objects[0][0][0] = $max
   return $objects
EndFunc

func objectorder($objects);merge objects together again in order
   dim $all[$objects[0][0][0]+1][4]
   $j = 1
   $i = 1
   $k = 1
   $h = 1
   $last = 0
   for $n = 1 to ubound($objects,2)-1
	  for $m = 1 to 3
		 if $objects[$m][$n][1] = "" Then $objects[$m][$n][1] = 1000000
	  Next
   Next
   Do
	  $objects[1][$i][1] = int($objects[1][$i][1])
	  $objects[2][$j][1] = int($objects[2][$j][1])
	  $objects[3][$h][1] = int($objects[3][$h][1])
	  if $objects[1][$i][1] = "" then $objects[1][$i][1] = 1000000
	  if $objects[2][$j][1] = "" then $objects[2][$i][1] = 1000000
	  if $objects[3][$h][1] = "" then $objects[3][$i][1] = 1000000
	  if $objects[1][$i][1] < $objects[2][$j][1] and $objects[1][$i][1] < $objects[3][$h][1] Then
		 $all[$k][1] = int($objects[1][$i][1])
		 $all[$k][2] = $objects[1][$i][2]
		 $i += 1
		 if $last <> 1 Then
		    $sublast = $last
		 EndIf
		 $last = 1
	  Elseif $objects[1][$i][1] > $objects[2][$j][1] and $objects[2][$j][1] < $objects[3][$h][1] Then
		 $all[$k][1] = int($objects[2][$j][1])
		 $all[$k][2] = $objects[2][$j][2]
		 $j += 1
		 if $last <> 2 Then
		    $sublast = $last
		 EndIf
		 $last = 2
	  ElseIf $objects[3][$h][1] < $objects[1][$i][1] and $objects[3][$h][1] < $objects[2][$j][1] Then
		 $all[$k][1] = int($objects[3][$h][1])
		 $all[$k][2] = $objects[3][$h][2]
		 $h += 1
		 if $last <> 3 Then
		    $sublast = $last
		 EndIf
		 $last = 3
	  Else
		 error(16)
	  EndIf
	  $k += 1
   until $k = $objects[0][0][0]+1
   dim $k[4]
   $k[1] = $i
   $k[2] = $j
   $k[3] = $h
   for $n = 1 to 3
	  if $n <> $sublast and $n <> $last Then
		 if $objects[$n][$k[$n]][1] <> 1000000 Then
		    $all[$objects[0][0][0]][1] = int($objects[$n][$k[$n]][1])
		    $all[$objects[0][0][0]][2] = $objects[$n][$k[$n]][2]
		 EndIf
	  EndIf
   Next
   $all[0][0] = $objects[0][0][0]
   return $all
EndFunc

func fixtimer($order,$coords,$bpm);set how much time relax will hold button, apply timing correction and alternating between buttons
   ReDim $order[$order[0][0]+1][6]
   $order[0][1] = $order[1][1]
   for $i = 1 to $order[0][0]
	  if $order[$i][2] = "slider" then
		 $order[$i][2] = calcslidertime($order[$i][1],$coords,$bpm,$i) + (int(random($holdmin,$holdmax)))
		 $acc = int(random($accmin,$accmax))
		 $order[$i][1] -= $acc
	  ElseIf $order[$i][2] = "tap" then
		 $order[$i][2] = $order[$i][1] + (int(random($holdmin,$holdmax)))
		 $acc = int(random($accmin,$accmax))
	     $order[$i][1] -= $acc
	     $order[$i][2] -= $acc
	  elseif stringinstr($order[$i][2],"-") Then
		 $order[$i][2] = number(stringmid($order[$i][2],stringinstr($order[$i][2],"-")+1))
		 $order[$i][5] = "spinner"
	  Else
		 error(17)
	  EndIf
	  if $i < $order[0][0] Then
	     if $order[$i][1] + $maxinterval > $order[$i+1][1] Then
		    if $order[$i-1][3] = "left" Then
	           $order[$i][3] = "right"
		       $order[$i][4] = $key[2]
		    Else
			   $order[$i][3] = "left"
		       $order[$i][4] = $key[1]
		    EndIf
	     Else
		    $order[$i][3] = "left"
		    $order[$i][4] = $key[1]
	     EndIf
	  Else
		 $order[$i][3] = "left"
		 $order[$i][4] = $key[1]
	  EndIf
   Next
   return $order
EndFunc

func calcslidertime($bpm,$inittime,$pixelLength,$sliderspdmult,$repeat)
   $k = ""
   for $j = 1 to $bpm[0][0]
	  if $bpm[$j][1] > $inittime Then
		 $k = $j - 1
		 ExitLoop
	  EndIf
   Next
   if $k = "" Then $k = $bpm[0][0]
   $slidertime = $bpm[$k][2] * ($pixelLength / $sliderspdmult) / 100
   $slidertime *= $repeat
   $totalslidertime = $slidertime + $inittime
   ;msgbox(0,"",$bpm[$k][2] & @CRLF & $inittime & @CRLF &  $pixelLength & @CRLF & $sliderspdmult & @CRLF & $repeat & @CRLF & $totalslidertime)
   return $totalslidertime
EndFunc

