#include <CommMG64.au3>
#include <Array.au3>

Func kaz_wadze_pisac_nonstop()
	While 1
		_CommSendString("C1" & @CRLF, 1)
		$w2 = _CommGetLine(@CR, 30, 300)
		If (StringInStr($w2, "C1 A")) Then
			Return 1
		EndIf
	WEnd
EndFunc   ;==>kaz_wadze_pisac_nonstop

Func kaz_wadze_podac_id()
	While 1
		_CommSendString("NB" & @CRLF, 1)
		$w2 = _CommGetLine(@CR, 30, 300)
		If (StringInStr($w2, "C0 A")) Then
			Return $w2
		EndIf
	WEnd
EndFunc   ;==>kaz_wadze_podac_id

Func kaz_wadze_przestac_pisac()
	For $i = 0 To 3
		_CommSendString("C0" & @CRLF, 1)
		$w2 = _CommGetLine(@CR, 30, 300)
		If (StringInStr($w2, "C0 A")) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>kaz_wadze_przestac_pisac

Func wydobadz_id_elementu($obj)
	Local $ComPort = $obj
	Local $sportSetError = '' ;String z bledem
	Local $ComBaud = 9600 ;baund rate  >> czestotliwosc zczytywania
	Local $CmboDataBits = 8 ;Liczba bitów w kodzie do przeslania.
	Local $CmBoParity = "0" ;No praity  $iParity - integer: 0=None,1=Odd,2=Even,3=Mark,4=Space
	Local $CmBoStop = 1 ;intiger: number of stop bits, 1=1 stop bit 2 = 2 stop bits, 15 = 1.5 stop bits
	Local $setflow = 2 ;nie wiem co :P
	_CommSetPort($ComPort, $sportSetError, $ComBaud, $CmboDataBits, $CmBoParity, $CmBoStop, $setflow) ;

	$id = 0
	If (kaz_wadze_przestac_pisac()) Then
		$id = kaz_wadze_podac_id()
		kaz_wadze_pisac_nonstop()
	EndIf
	_CommClosePort()
	Return $id
EndFunc   ;==>wydobadz_id_elementu


$lista_portow = _CommListPorts(2)

For $port In $lista_portow
ConsoleWrite(wydobadz_id_elementu($port) & @CRLF)
Next

;Utworz liste ktora bedzie zawierala nazwe portu oraz to co jest do niego wpiete