#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <CommMG64.au3>

;LABELE
$Working_network_OK = "Dzialam"
$Working_network_BAD = "Dzialam, BRAK SIECI"
$NOT_WORKING = "BRAK WAGI NA USB"


Global $ComPort = 4
Global $sportSetError = ''  ;String z bledem
Global $ComBaud = 9600 ;baund rate  >> czestotliwosc zczytywania
Global $CmboDataBits = 8  ;Liczba bitów w kodzie do przeslania.
Global $CmBoParity = "0" ;No praity  $iParity - integer: 0=None,1=Odd,2=Even,3=Mark,4=Space
Global $CmBoStop = 1  ;intiger: number of stop bits, 1=1 stop bit 2 = 2 stop bits, 15 = 1.5 stop bits
Global $setflow = 2 ;nie wiem co :P
_CommSetPort($ComPort, $sportSetError, $ComBaud, $CmboDataBits, $CmBoParity, $CmBoStop, $setflow)

$w1 = _CommGetString() ;Wczytaj jakikolwiek string "PROWIZORKA"


Opt("GUIResizeMode", $GUI_DOCKBOTTOM)
#Region ### START Koda GUI section ### Form=c:\users\marcinan\documents\waga1.kxf
$Form1_1 = GUICreate("Nazwa Wagi", 790, 259, 201, 339, -1, BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$work_status_label = GUICtrlCreateLabel("Dzialam", 16, 8, 754, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE,$SS_SUNKEN,$WS_BORDER))
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Wyswietla co sie teraz dzieje")
$Wyslij_button = GUICtrlCreateButton("Wyslij", 8, 192, 289, 57)
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Wysyla wage do serwera")
$Cofnij_button = GUICtrlCreateButton("Cofnij", 496, 192, 281, 57)
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Cofa wczeniej wys³an¹ wagê. Nie t¹ któr¹ masz na ekranie tylko t¹ co wczesniej wyslales")
$Taruj_button = GUICtrlCreateButton("Taruj", 320, 192, 153, 57)
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Taruje wage")
$Waga = GUICtrlCreateLabel("Waga", 16, 96, 756, 82, BitOR($SS_RIGHT,$SS_CENTERIMAGE,$WS_BORDER))
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetTip(-1, "Wyswietla wage z urz¹dzenia")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1

$w2 = _CommGetLine(@CR, 30, 300)
if Not($w1 == $w2) Then
GUICtrlSetData($Waga, $w2)
EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Taruj_button
			taruj()
		Case $Cofnij_button
			cofnij()
		Case $Wyslij_button
			wyslij()


	EndSwitch
WEnd

Func sprawdz_polaczenie_z_serwerem()
$ping = Ping( "10.185.40.31" , 8000)
if $ping Then

	EndIf
	EndFunc

Func kaz_wadze_pisac_nonstop()
_CommSendString("C1"&@CRLF,1)
	EndFunc

Func wyslij()

EndFunc


Func cofnij()

	EndFunc

Func taruj()
	GUICtrlSetData($work_status_label,"Taruje")
	_CommSendString("T"&@CRLF,1)
	kaz_wadze_pisac_nonstop()
	sleep(1000);
	GUICtrlSetData($work_status_label,"Dzialam")
	;_CommSendByte("T"&@CRLF,1)
EndFunc
