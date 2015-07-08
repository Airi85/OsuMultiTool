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

func getnotediameter()
   $sdiameter = 104 - ($diff[2] * 8)
   $dmult = $screenres[1] / 640
   $finaldiameter = $dmult * $sdiameter
   return $finaldiameter
EndFunc

func getnotestackinglimit()
   return (1800*$diff[7]) - ($diff[4] * (150*$diff[7]))
EndFunc

