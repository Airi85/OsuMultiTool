func gethitobjects($version);get all hit objects
   local $hitobjects[1]
   $h = 1
   $handle = fileopen($songfile)
   $filecontent = FileRead($handle)
   $filecontent = stringsplit($filecontent,"[HitObjects]",1);take all content below [HitObjects] to filecontent[2]
   $nhitobjects = stringsplit($filecontent[2],@CRLF);separate content from filecontent[2] every line separately in a array
   for $i = 1 to $nhitobjects[0] step 1           ;\
	  guictrlsetdata($Labelready2,round((($i / $nhitobjects[0]) * 40)+10,2) & "%")
	  if stringinstr($nhitobjects[$i],",") Then ;\
		 $h += 1
		 redim $hitobjects[$h]
		 $hitobjects[$h-1] = $nhitobjects[$i]              ;- delete data from the array that isn't hit objects
	  EndIf                                        ;/
   Next                                            ;/
   $hitobjects[0] = ubound($hitobjects)-1;set the max index of $hitobjects to $hitobjects[0]
   fileclose($handle)
   ;_ArrayDisplay($hitobjects)
   return $hitobjects
EndFunc

func calcslidertime($bpm,$inittime,$pixelLength,$sliderspdmult,$repeat)
   $k = -1
   for $j = 1 to $bpm[0][0]
	  if $bpm[$j][1] > $inittime Then
		 $k = $j - 1
		 ExitLoop
	  EndIf
   Next
   if $k = -1 Then $k = $bpm[0][0]
   if $k = 0 then $k = 1
   $slidertime = $bpm[$k][2] * ($pixelLength / $sliderspdmult) / 100
   $slidertime *= $repeat
   $totalslidertime = $slidertime + $inittime
   ;msgbox(0,"",$bpm[$k][2] & @CRLF & $inittime & @CRLF &  $pixelLength & @CRLF & $sliderspdmult & @CRLF & $repeat & @CRLF & $totalslidertime)
   return $totalslidertime
EndFunc

func getnotediameter()
   $sdiameter = 104 - ($diff[2] * 8)
   $dmult = $screenres[1] / 640
   $finaldiameter = $dmult * $sdiameter
   return $finaldiameter
EndFunc

func getnotestackinglimit()
   return (1800*$diff[7]) - ($diff[4] * (150*$diff[7]))
EndFunc

