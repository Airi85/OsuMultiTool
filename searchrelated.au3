func listosufiles($folder,$extension = ".osu");list all .osu files in a array  [1] = difficulty  [2] = full path
   dim $files[1][3]
   $j = 1
   $file = _FileListToArray($folder)
   for $i = 1 to $file[0]
	  $temp = stringsplit($file[$i],".")
	  if $temp[$temp[0]] = "osu" Then
		 redim $files[$j+1][3]
		 $files[$j][1] = stringmid($file[$i],stringinstr($file[$i],"["),stringlen($file[$i]) - stringinstr($file[$i],"[") - 3)
		 $files[$j][2] = $folder & $file[$i]
		 consolewrite($files[$j][2] & @CRLF)
		 $j += 1
	  EndIf
   Next
   $files[0][0] = ubound($files)-1
   return $files
EndFunc

func search($folder,$string);search for a song in the osu folder, returns a array with every song that matches the search
   if stringlen($string) < 3 then return -1
   dim $afolder[1][4]
   $j = 1
   $folders = _FileListToArray($folder)
   $afolder[0][1] = 0
   for $i = 1 to $folders[0]
      if stringinstr($folders[$i],$string) then
		 $afolder[0][1] = 1
	     $temp = stringsplit($folders[$i]," ")
	     if $temp[0] >= 3 Then
		    for $k = 3 to $temp[0]
			   $temp[2] &= " " & $temp[$k]
		    Next
	     EndIf
	     redim $afolder[$j+1][4]
	     $afolder[$j][1] = $temp[2]
	     $afolder[$j][2] = $temp[1]
		 $afolder[$j][3] = $folders[$i] & "\"
		 $j += 1
      EndIf
   Next
   $afolder[0][0] = ubound($afolder)-1
   if $afolder[0][1] = 0 then return -1
   return $afolder
EndFunc

func listsongs($asongs);list all songs returned by search() in a listview gui
   guictrldelete($listsongs[1])
   redim $listsongs[$asongs[0][0]+2]
   $listsongs[1] = GUICtrlCreateListView("Song Name|Song ID", 8, 40, 314, 198, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_SORTASCENDING,$LVS_AUTOARRANGE,$WS_HSCROLL,$WS_VSCROLL))
   GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 300)
   for $i = 1 to $asongs[0][0]
	  $listsongs[$i+1] = GUICtrlCreateListViewItem($asongs[$i][1] & "|" & $asongs[$i][2],$listsongs[1])
   Next
EndFunc

func listdiff($msg,$asongs);list all song difficultys returned by listosufiles() in radio buttons
   if not IsArray($asongs) then return -1
   $hdiff = 90
   for $i = 1 to ubound($listdiff)-1
	  GUICtrlDelete($listdiff[$i][1])
   Next
   for $i = 2 to ubound($listsongs)-1
	  if $listsongs[$i] = $msg Then
		 $osufiles = listosufiles($loc & $asongs[$i-1][3])
		 redim $listdiff[$osufiles[0][0]+1][3]
		 GUIStartGroup()
		 for $j = 1 to $osufiles[0][0]
			$listdiff[$j][1] = GUICtrlCreateRadio($osufiles[$j][1], 392, $hdiff, 125, 17)
			$listdiff[$j][2] = $osufiles[$j][2]
			$hdiff += 20
		 Next
	  EndIf
   Next
EndFunc