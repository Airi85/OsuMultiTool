; #FUNCTION# ====================================================================================================================
; Name ..........: _AOBScan
; Description ...: Finds a pattern in a process
; Syntax ........: _AOBScan($handle, $sig)
; Parameters ....: $handle              - Handle of the process the pattern should be find in.
;                  $sig                 - The pattern/signature to be found.
; Return values .: - adress	Adress of the begin of the pattern.
;				   - 0		There was an error
; Author ........: Unknown
; Modified ......: by Airi85
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AOBScan($handle, $sig)
   $queryinfo = getqueryinfo($handle,0x7fff0000,0x01000000,0x40)
	$sig = StringRegExpReplace($sig, "[^0123456789ABCDEFabcdef?.]", "")
	$sig = StringRegExpReplace($sig, "[?]", ".")
	Local $bytes = StringLen($sig) / 2
	$scanbuffer = DllStructCreate("byte[" & $queryinfo[0][1] & "]")
	$scanbptr = DllStructGetPtr($scanbuffer)
	for $i = 1 to $queryinfo[0][0]
	   ;consolewrite($queryinfo[$i][1] & " " & $queryinfo[$i][2] & @CRLF)
		DllCall($handle[0], 'int', 'ReadProcessMemory', 'int', $handle[1], 'int', $queryinfo[$i][1], 'ptr', $scanbptr, 'int', $queryinfo[$i][2], 'int', '')
		$regbuffer = dllstructcreate("byte[" & $queryinfo[$i][2] & "]",$scanbptr)
		StringRegExp(DllStructGetData($regbuffer,1), $sig, 1, 2)
		If @error = 0 Then
			return StringFormat("0x%.8X", $queryinfo[$i][1] + ((@extended - StringLen($sig) - 2) / 2))
			return $result
		EndIf
	Next
	Return 0
 EndFunc   ;==>_AOBScan

 func getqueryinfo($ph,$end_addr = 0x7fffffff,$precision = 0x01000000,$prot = "")
	Local $stMemInfo=DllStructCreate("ptr;ptr;dword;ulong_ptr;dword;dword;dword"),$iStrSz=DllStructGetSize($stMemInfo),$stMemInfoptr = DllStructGetPtr($stMemInfo)
	$addr = 0x00010000
	local $result[1000001][3]
	$i = 0
	$highest = 0
	local $queryaccess
	while $addr < $end_addr
	    $queryaccess = false
		DllCall($ph[0],"ulong_ptr","VirtualQueryEx","handle",$ph[1],"ptr",$addr,"ptr",$stMemInfoptr,"ulong_ptr",$iStrSz)
		if dllstructgetdata($stMemInfo,6) = $prot or "" = $prot then $queryaccess = true
		if dllstructgetdata($stMemInfo,5) = 0x1000 and dllstructgetdata($stMemInfo,7) <> 0x40000 and $queryaccess = true then
		    $i += 1
		    $result[$i][1] = dllstructgetdata($stMemInfo,1)
		    $result[$i][2] = dllstructgetdata($stMemInfo,4)
			if $result[$i][2] > $highest then $highest = $result[$i][2]
			if $result[$i][2] > $precision Then
				$result[$i][2] = $precision
				$curdec = $precision
				while 1
					$i += 1
					$result[$i][1] = $result[$i-1][1] + $precision
					if dllstructgetdata($stMemInfo,4) - $curdec > $precision then
					    $result[$i][2] = $precision
						$curdec += $precision
					Else
						$result[$i][2] = dllstructgetdata($stMemInfo,4) - $curdec
						ExitLoop
					EndIf
				WEnd
			EndIf
		EndIf
		$addr = dllstructgetdata($stMemInfo,1) + dllstructgetdata($stMemInfo,4)
	WEnd
	redim $result[$i+1][3]
	$result[0][0] = $i
	$found = true
	if $highest > $precision Then
		$result[0][1] = $precision
	Else
		$result[0][1] = $highest
	EndIf
	return $result
EndFunc
