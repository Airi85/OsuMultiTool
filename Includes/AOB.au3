; #FUNCTION# ====================================================================================================================
; Name ..........: _AOBScan
; Description ...: Finds a pattern in a process
; Syntax ........: _AOBScan($handle, $sig)
; Parameters ....: $handle              - Handle of the process the pattern should be find in.
;                  $sig                 - The pattern/signature to be found.
; Return values .: - adress	Adress of the begin of the pattern.
;				   - 0		There was an error
; Author ........: Unknown
; Modified ......: by Icclear
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AOBScan($handle, $sig)
	Local $Mult = 1600
	$sig = StringRegExpReplace($sig, "[^0123456789ABCDEFabcdef?.]", "")
	$sig = StringRegExpReplace($sig, "[?]", ".")
	Local $bytes = StringLen($sig) / 2

;~ 	Local $start_addr = 0x00400000
;~ 	Local $end_Addr = 0x0FFFFFFF
	Local $start_addr = 0x00000000
	Local $end_Addr = 0x7FFFFFFF

	For $addr = $start_addr To $end_Addr Step 256
		StringRegExp(_MemoryRead($addr, $handle, "byte[256]"), $sig, 1, 2)
		If @error = 0 Then
			Return StringFormat("0x%.8X", $addr + ((@extended - StringLen($sig) - 2) / 2))
		EndIf
	Next
	Return 0
 EndFunc   ;==>_AOBScan
