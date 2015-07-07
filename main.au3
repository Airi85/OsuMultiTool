#RequireAdmin
#include <Array.au3>
#include "Includes\NomadMemory.au3"
#include "Includes\AOB.au3"
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <File.au3>
#include "GUIrelated.au3"
#include "searchrelated.au3"
#include "aimrelated.au3"
#include "fileinfo.au3"
#include "relaxrelated.au3"
#include "tools.au3"
global $poshotkeys = "{Home}|{END}|{insert}|{delete}|{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}"
global $config = "config.ini"
global $osumap
global $User32 = dllopen("User32.dll")
if iniread($config,"GENERAL","FIRSTRUN",0) = 0 Then
   $windowname = inputbox("","Enter your desired Window Name: " & @CRLF & @CRLF & "(can change again in the options)","")
   if @ERROR then _exit()
   $screenres = inputbox("","Enter your in-game screen resolution: " & @CRLF & 'Example: "1280x720" (no spaces and the "x" is necessary)' & @CRLF & @CRLF & "(can change again in the options)",@DesktopWidth & "x" & @DesktopHeight)
   if @ERROR then _exit()
   $sensibility = inputbox("","Enter your in-game mouse sensibility: " & @CRLF & 'Example: "1.32" (no spaces, use dot to separate the integer from decimal)' & @CRLF & @CRLF & "(can change again in the options)","1.00")
   if @error then _exit()
   iniwrite($config,"GENERAL","windowname",$windowname)
   iniwrite($config,"GENERAL","screenresolution",$screenres)
   iniwrite($config,"GENERAL","sensibility",$sensibility)
   iniwrite($config,"GENERAL","FIRSTRUN",1)
Else
   $error0 = 0
   $windowname = iniread($config,"GENERAL","windowname","0")
   if $windowname = "0" then error(1)
   $screenres = iniread($config,"GENERAL","screenresolution","0")
   if $screenres = "0" then error(1)
   $sensibility = iniread($config,"GENERAL","sensibility","0")
   if $sensibility = "0" then error(1)
EndIf
SplashTextOn("","Please wait while information is being gathered",500,100,default,default,32)
global $movetime = iniread($config,"aimbot","movetime",1000)
global $correctionradius = iniread($config,"aimcorrection","correctionradius",100)
global $accmin = iniread($config,"relax","accmin",0)
global $accmax = iniread($config,"relax","accmax",50)
global $holdmin = iniread($config,"relax","holdmin",40)
global $holdmax = iniread($config,"relax","holdmax",80)
global $maxinterval = iniread($config,"relax","maxinterval",179)
global $ycorrection = iniread($config,"aim","ycorrection",35)
global $slideracc = iniread($config,"aimbot","slideracc",20)
global $sliderspdcorrection = iniread($config,"aimbot","sliderspdcorrection",0.95)
global $lookonline = iniread($config,"GENERAL","lookonline",1)
global $usemouse = iniread($config,"relax","usemouse",1)
global $key = stringsplit(iniread($config,"relax","key","z,x"),",")
global $keycodes = getkeycodes()
global $htmlname = iniread($config,"GENERAL","htmlname","g5i60ntyqx.html")
global $hotkey = stringsplit(iniread($config,"GENERAL","hotkey","{END},{HOME}"),",")
global $spinlinemin = iniread($config,"autospin","spinlinemin",75)
global $spinlinemax = iniread($config,"autospin","spinlinemax",150)
global $spinvariation = IniRead($config,"autospin","spinvariation",10)
global $spinsps = iniread($config,"autospin","spinsps",10)
hotkeyset($hotkey[1],"_exit")
hotkeyset($hotkey[2],"mainguiloop")
$screenres = stringsplit($screenres,"x")
$sensibility = number($sensibility)
if not processexists("osu!.exe") Then
   error(2)
EndIf
$osupid = ProcessWait("osu!.exe")
global $osumap = _MemoryOpen($osupid)
if @error then error(@error+2)
global $loc = stringleft(Processgetlocation($osupid),stringlen(Processgetlocation($osupid))-8) & "Songs\"
$address = findaddress()
;$address = getaddress()
;$address = 0x00286EAC
if not IsArray($address) Then
   error(12)
EndIf
$h = WinGetHandle("osu!")
if @error then error(18)
$rect = dllstructcreate("struct;long left;long top;long right;long bottom;endstruct")
if @error then error(@error+6)
dllcall($User32,"bool","GetClientRect","hwnd",$h,"struct*",$rect)
if @error then error(19)
$screenres[1] = _MemoryRead($address[6],$osumap)
$screenres[2] = _MemoryRead($address[7],$osumap)
global $final = ""
global $mode = 0
global $xmod = ($screenres[2] / 496)
global $ymod = ($screenres[2] / 496)
global $scale = $screenres[2] / 480
global $marginLeft = ((640 - 512) * $scale / 2) + (($screenres[1] - (800 * $screenres[2] / 600)) / 2)
global $marginTop = ((480 - 384) * $scale / 2)
global $osuCoordX = dllstructgetdata($rect,1)
global $osuCoordY = dllstructgetdata($rect,2)
if $osuCoordY = 0 and $osuCoordX = 0 then $osuCoordY = 13
global $listsongs
dim $listsongs[3]
global $listdiff
dim $listdiff[2][3]
$listdiff[1][1] = 1000000
global $songs
global $diffselected = ""
global $exitt = 0
global $songfile
global $version
global $coords
global $final
global $diff
;global $bpm
global $exit
global $spin
global $useinternal = 0
global $hardrock = 0
Global $buffer = DllStructCreate('dword')
global $bufferptr = DllStructGetPtr($buffer)
global $buffersize = DllStructGetSize($buffer)
;global $rtdll = dllopen("rt.dll")
;global $ntdll = dllopen("ntdll.dll")
splashoff()
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($windowname, 615, 436, 190, 213)
$menutab = guictrlcreatemenu("Options")
$hotkeystab = GUICtrlCreateMenuitem("Hotkeys",$menutab)
$optionstab = GUICtrlCreateMenuitem("Options",$menutab)
$securitytab = GUICtrlCreateMenuitem("Security",$menutab)
$toolswin = GUICtrlCreateGroup("Select Tool", 16, 272, 241, 120)
GUIStartGroup()
$relaxbox = GUICtrlCreateRadio("Relax", 24, 296, 73, 17)
$aimccbox = GUICtrlCreateRadio("Aim Correction", 24, 320, 89, 17)
$aimbotbox = GUICtrlCreateRadio("Aimbot", 24, 344, 65, 17)
$relaxccbox = GUICtrlCreateRadio("Relax + Aim Correction", 120, 296, 137, 17)
$relaxbotbox = GUICtrlCreateRadio("Relax + Aimbot", 120, 320, 113, 17)
$spinrad = GUICtrlCreateRadio("Auto Spin only", 120, 344, 113, 17)
$spinbox = GUICtrlCreateCheckbox("Auto Spin", 24, 368, 89, 17)
;$useinternalbox = GUICtrlCreateCheckbox("Use internal timestamp", 120, 368, 129, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$search = GUICtrlCreateInput("Enter Song Name", 24, 16, 233, 21)
$listsongs[1] = GUICtrlCreateListView("Song Name|Song ID", 8, 40, 314, 198, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_SORTASCENDING,$LVS_AUTOARRANGE,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 300)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
$selectdiff = GUICtrlCreateGroup("Select Difficulty", 384, 74, 137, 92)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$loadbutton = GUICtrlCreateButton("Load", 528, 104, 75, 25)
global $Labelready = GUICtrlCreateLabel("Ready:", 400, 280, 38, 17)
global $Labelready2 = GUICtrlCreateLabel("No", 438, 280, 18, 17)
global $Labelstatus = GUICtrlCreateLabel("Status:", 400, 304, 37, 17)
global $Labelstatus2 = GUICtrlCreateLabel("Not Initialized", 438, 304, 150, 17)
$initbutton = GUICtrlCreateButton("Initialize", 264, 312, 75, 25)
$updatebutton = GUICtrlCreateButton("Update Song List", 256, 16, 99, 25)
$hrbox = GUICtrlCreateCheckbox("Hardrock", 528, 80, 97, 17)
guiregistermsg($WM_COMMAND,"buttonpressed")
GUICtrlSetColor($Labelready2,"0xFF0000")
GUICtrlSetColor($Labelstatus2,"0xFF0000")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
mainguiloop()

func findaddress();finds the address [1]-[4] time addresses [5] = active song [6] = xres [7] = yres
   dim $address[8]
   $aob = "B4 17 00 00 14 13 00 00 B8 17 00 00 14 13 00 00"
   $add = _AOBScan($osumap,$aob)
   $address[1] = $add + 0xA20
   $address[2] = $address[1] + 0x4
   $address[3] = $address[1] + 0x8
   $address[4] = $address[1] + 0xC
   $address[5] = $address[1] + 0xA34
   $address[6] = $address[1] + 0x160
   $address[7] = $address[6] + 0x4
   if $add <> 0 Then
      return $address
   EndIf
   if $lookonline = 1 Then
	  filedelete($htmlname)
      inetget("http://freetexthost.com/g5i60ntyqx",$htmlname)
   EndIf
   dim $taddress[5]
   dim $temp[5]
   dim $aaddress[65536][5]
   dim $atemp[65536][5]
   $h = fileopen($htmlname)
   $filecontent = fileread($h)
   $filecontent = stringsplit($filecontent,"[Changeable Info]",1)
   $filecontent[2] = stringmid($filecontent[2],9,20)
   $ad = stringsplit($filecontent[2]," ")
   fileclose($h)
   $success = 0
   for $i = 0 to 65535
      $hex = stringmid(hex($i),5)
	  $temp[1] = "0x" & $hex & $ad[3] & $ad[4]
	  $temp[2] = "0x" & $hex & $ad[3] & $ad[5]
      $temp[3] = "0x" & $hex & $ad[3] & $ad[6]
	  $temp[4] = "0x" & $hex & $ad[3] & $ad[7]
	  ConsoleWrite($temp[1])
	  $atemp[$i][1] = $temp[1]
	  $atemp[$i][2] = $temp[2]
	  $atemp[$i][3] = $temp[3]
	  $atemp[$i][4] = $temp[4]
	  for $j = 1 to 4
         $taddress[$j] = _MemoryRead($temp[$j],$osumap)
		 if @error then error(@error+5)
		 $aaddress[$i][$j] = $taddress[$j]
	  Next
	  if $taddress[1] < 1000000 and $taddress[1] > 0 and $taddress[1] = $taddress[2] Then
		 $addiff = $taddress[1] - $taddress[3]
		 $bddiff = $taddress[1] - $taddress[4]
		 if $addiff < 0 Then
			$addiff *= -1
		 EndIf
		 if $bddiff < 0 Then
			$bddiff *= -1
		 EndIf
		 if $addiff < 1000 Then
			$success += 1
		 EndIf
		 if $bddiff < 1000 Then
			$success += 1
		 EndIf
		 if $success = 2 Then return $temp
	  EndIf
   Next
   for $i = 0 to 5000
	  if not FileExists("log" & $i & ".ini") Then
		 $log = "log" & $i & ".ini"
		 ExitLoop
	  EndIf
   Next
   $logad = "address"
   $logval = "value"
   for $i = 0 to 1000
	  iniwrite($log,"success",0,$success)
	  iniwrite($log,$logad,$i,$atemp[$i][1] & "|" & $atemp[$i][2] & "|" & $atemp[$i][3] & "|" & $atemp[$i][4])
	  iniwrite($log,$logval,$i,$aaddress[$i][1] & "|" & $aaddress[$i][2] & "|" & $aaddress[$i][3] & "|" & $aaddress[$i][4])
   Next
EndFunc

func _exit();exit tool and close handles
   msgbox(0,"Exit","The tool is exiting now")
   if IsDeclared($osumap) then
      _MemoryClose($osumap)
   EndIf
   Exit
EndFunc

Func ProcessGetLocation($iPID);get process location, function not by me, got it in autoit forums
   Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
   If $aProc[0] = 0 Then Return SetError(1, 0, '')
   Local $vStruct = DllStructCreate('int[1024]')
   DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int_ptr', 0)
   Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
   If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
   Return $aReturn[3]
EndFunc


func stop();set $exit to 1 making every tool to exit and unnitialize tool
   $exit = 1
EndFunc

func launchrelax($notes);launch relax in a DllCall(tried to write relax in c++ to make it more precise but failed every time relax function is called the process stops working(i dont have experience with c++))
   for $i = 1 to $notes[0][0]
	  ;_arraydisplay($notes)
	  if $notes[$i][3] = "left" Then
		 $notes[$i][3] = 1
	  ElseIf $notes[$i][3] = "right" Then
		 $notes[$i][3] = 2
	  Else
		 $notes[$i][3] = 1
	  EndIf
   Next
   $relaxbuffer = DllStructCreate('dword')
   dllcall($rtdll,'int','relax','dword*',$notes,'int',$address[2],'int',$osumap[1],'dword',$usemouse,'word',$keycodes,'ptr',DllStructGetPtr($relaxbuffer))
   if @error then msgbox(0,"",@error)
   msgbox
   while 1
	  if dllstructgetdata($relaxbuffer,1) = 1 Then
		 ExitLoop
	  EndIf
	  if dllstructgetdata($relaxbuffer,1) > 1 then
		 msgbox(0,"",dllstructgetdata($relaxbuffer,1))
	  EndIf
   WEnd
EndFunc

func getkeycodes();get keycodes to be used in launchrelax()
   dim $tkeycodes[3]
   local $poskeys[27]  = [26,"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
   local $eqkeys[27] = [26,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A]
   for $a = 1 to 2
      for $i = 1 to $poskeys[0]
	     if $key[$a] = $poskeys[$i] Then
		    $tkeycodes[$a] = $eqkeys[$i]
	     EndIf
      Next
   Next
   return $tkeycodes
EndFunc

func error($Nerror);semi error handler
   splashoff()
   switch $Nerror
      case 1
	     msgbox(0,"Error","Something went wrong: Reading ini" & @CRLF & "error code: " & 1)
	     $asw = msgbox(0,"Reset","do you want to delete the ini?" & @CRLF & "(if the error is persisting deleting the ini is an option, it will reset all your saved informations)")
	     if $asw = 1 Then
		    filedelete($config)
		    msgbox(0,"Success","Ini deleted succefully, reboot the tool")
		    _exit()
	     endif
	  case 2
		 msgbox(0,"Error","Can't detect Osu! running" & @CRLF & "error code: " & 2)
         _exit()
	  case 3
		 msgbox(0,"Error","error code: " & 3)
		 _exit()
	  case 4
		 msgbox(0,"Error","Failed to open Kernel32.dll" & @CRLF & "error code: " & 4)
		 _exit()
	  case 5
		 msgbox(0,"Error","Failed to attach to Osu!.exe" & @CRLF & "error code: " & 5)
		 _exit()
	  case 6
		 msgbox(0,"Error","error code: " & 6)
		 _exit()
	  case 7
		 msgbox(0,"Error","error code: " & 7)
		 _exit()
	  case 8
		 msgbox(0,"Error","error code: " & 8)
		 _exit()
	  case 9
		 msgbox(0,"Error","Failed to allocate memory" & @CRLF & "error code: " & 9)
		 _exit()
	  case 10
		 msgbox(0,"Error","Failed to allocate memory" & @CRLF & "error code: " & 10)
		 _exit()
	  case 11
		 msgbox(0,"Error","Failed to read Osu! memory" & @CRLF & "error code: " & 11)
		 _exit()
	  case 12
		 msgbox(0,"Error","Something went wrong: Finding address" & @CRLF & "error code: " & 12)
		 _exit()
	  case 13
		 msgbox(0,"Error","Something went wrong: Get Points" & @CRLF & "error code: " & 13)
	  case 14
		 msgbox(0,"Error","something went wrong: Color Points" & @CRLF & "error code: " & 14)
	  case 15
		 msgbox(0,"Error","Somenting went wrong: Calculate BPM" & @CRLF & "error code: " & 15)
	  case 16
	     msgbox(0,"Error","something went wrong : Object Order" & @CRLF & "error code: " & 16)
	  case 17
		 msgbox(0,"Error","something went wrong: Fix Timer" & @CRLF & "error code: " & 17)
	  case 18
		 msgbox(0,"Error","Failed to get Osu! handle" & @CRLF & "error code: " & 18)
		 _exit()
	  case 19
		 msgbox(0,"Error","Failed to detect Osu! coordinates" & @CRLF & "error code: " & 19)
		 _exit()
	  case 20
		 msgbox(0,"Error","Something went wrong: P slider" & @CRLF & "error code: " & 20)
		 mainguiloop()
	  case 21
		 msgbox(0,"Error","Unsupported slider type" & @CRLF & "error code: " & 21)
		 mainguiloop()
	  case 22
		 msgbox(0,"Error","Unsupported slider type" & @CRLF & "error code: " & 22)
		 mainguiloop()
	  case 23
		 msgbox(0,"Error","Something went wrong: Slider time" & @CRLF & "error code: " & 23)
   EndSwitch
EndFunc

func positive($number)
   if $number < 0 Then return ($number * -1)
   return $number
EndFunc

func fixangle($x,$y,$a)
   If $x >= 0 Then; 0 - 180
	  If $y <= 0 Then; 0 - 90
		 $angle = 90-$a
	  Else; 90 - 180
		 $angle = 90+$a
	  EndIf
   Else; 180 - 360
	  If $y >= 0 Then; 180 - 270
		 $angle = 180+(90-$a)
	  Else; 270 - 360
		 $angle = 270+$a
	  EndIf
   EndIf
   $angle -= 90
   if $angle <= 0 then $angle += 360
   return $angle
EndFunc

