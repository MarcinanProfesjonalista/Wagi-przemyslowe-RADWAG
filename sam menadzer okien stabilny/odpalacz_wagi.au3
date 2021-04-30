#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <CommMG64.au3>
#include <Array.au3>

;Do testow CMD odpalacz_wagi.exe "ip serwera1;Nazwa wagi2;X3; Y4;port COM5;Unikatowy id wagi;waga piecowa = 0 waga farby = 16;COM fo którego podlaczony jest pilot danej wagi"

Global Const $HTTP_STATUS_OK = 200 ;Poprawna odpowiedz serwera bez przekierowania
Global $ostatnie_dane_nadane = 0
Global $tablica_niewyslanych_danych


If $CmdLine[0] == 0 Then
	MsgBox($MB_SYSTEMMODAL, "Blad uruchomienia", "Uruchom przez gui.exe", 3)
;	Exit ;Wywal program jak nie dostaniesz argumentu
EndIf

;Global $CmdLine[2]  = ["1" , "1.1.1.1/test/insert.php;Waga pieca od sciany;0;0;4;2;0;1"]


;Nazwa wagi;port COM;Unikatowy id wagi;waga piecowa = 0 waga farby = 1
Global $tablica_stringow = StringSplit($CmdLine[1], ";")
;_ArrayDisplay($tablica_stringow,"Ustawienia wagi")
Global $adres_skryptu = $tablica_stringow[1]
Global $nazwa_wagi = $tablica_stringow[2]
Global $pozycjaX = $tablica_stringow[3]
Global $pozycjaY = $tablica_stringow[4]
Global $port_com = $tablica_stringow[5]
Global $id_wagi = $tablica_stringow[6]
If ($tablica_stringow[0] > 6) Then Global $rodzaj_wagi = $tablica_stringow[7]
If ($tablica_stringow[0] > 7) Then Global $port_pilota = $tablica_stringow[8]


;LABELE
Global $network_OK = "Serwer jest ok :)"
Global $network_BAD = "BRAK SERWERA :("
Global $NOT_WORKING = "BRAK WAGI NA USB :|"
Global $WORKING = "Dzialam "

;Skladnia
Global $SIEC = "-"
Global $WAGA = "-"
Global $dane = ""

Global $ComPort = $port_com
Global $sportSetError = ''  ;String z bledem
Global $ComBaud = 9600 ;baund rate  >> czestotliwosc zczytywania
Global $CmboDataBits = 8  ;Liczba bitów w kodzie do przeslania.
Global $CmBoParity = "0" ;No praity  $iParity - integer: 0=None,1=Odd,2=Even,3=Mark,4=Space
Global $CmBoStop = 1  ;intiger: number of stop bits, 1=1 stop bit 2 = 2 stop bits, 15 = 1.5 stop bits
Global $setflow = 2 ;nie wiem co :P
;_CommSetPort($ComPort, $sportSetError, $ComBaud, $CmboDataBits, $CmBoParity, $CmBoStop, $setflow);

;_CommSendString("niekomenda" & @CRLF, 1)
;$w1 = _CommGetString() ;Wczytaj jakikolwiek string "PROWIZORKA"
;
;If (StringInStr($w1, "ES") == 0) Then
;	MsgBox($MB_SYSTEMMODAL, "Blad polaczenia z waga", "Sprawdz port COM: " & $port_com, 10) ;Niema polaczenia miedzy waga a tym urzadzeniem. Sprawdz do ktorego portu jest podlaczona waga
;	Exit ;Wywal program jak nie dostaniesz odpowiedzi ES
;EndIf


	Opt("GUIResizeMode", $GUI_DOCKBOTTOM)
	#Region ### START Koda GUI section ### Form=c:\users\marcinan\documents\waga1.kxf
	$Form1_1 = GUICreate($nazwa_wagi, 790, 259, $pozycjaX, $pozycjaY, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$work_status_label = GUICtrlCreateLabel("Dzialam", 16, 8, 754, 80, BitOR($SS_CENTER, $SS_CENTERIMAGE, $SS_SUNKEN, $WS_BORDER))
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Wyswietla co sie teraz dzieje")
	$Taruj_button = GUICtrlCreateButton("Taruj", 320, 192, 153, 57)
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Taruje wage")
If ($rodzaj_wagi == 0) Then
	$Wyslij_button = GUICtrlCreateButton("Wyslij", 8, 192, 289, 57)
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Wysyla wage do serwera")
	$Cofnij_button = GUICtrlCreateButton("Cofnij", 496, 192, 281, 57)
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Cofa wczeniej wys³an¹ wagê. Nie t¹ któr¹ masz na ekranie tylko t¹ co wczesniej wyslales")
ElseIf ($rodzaj_wagi == 1) Then
	$Wyslij_button = GUICtrlCreateButton("Waz!", 8, 192, 289, 57)
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Wysyla wage do serweraw czasie rzeczywistym")
	$Cofnij_button = GUICtrlCreateButton("Przerwa wazenia", 496, 192, 281, 57)
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Pauzuje wysylanie danych do serwera na czas zmiany wiadra")
EndIf
	$WAGA = GUICtrlCreateLabel("Waga", 16, 96, 756, 82, BitOR($SS_RIGHT, $SS_CENTERIMAGE, $WS_BORDER))
	GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetTip(-1, "Wyswietla wage z urz¹dzenia")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###


Global $licznik_petli = 0 ;

While 1
	;	If $licznik_petli == 0 Then
	;		sprawdz_polaczenie_z_serwerem()
	;	ElseIf $licznik_petli > 300 Then ;Tu regulujesz obciazenie sieci przez komende ping.
	;		$licznik_petli = 0
	;		wypisz_stan_wagi()
	;	EndIf
	;	$licznik_petli = $licznik_petli + 1


	;	$w2 = _CommGetLine(@CR, 30, 300)
	;	If Not ($w1 == $w2) Then
	;		GUICtrlSetData($WAGA, $w2)
	;	EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Taruj_button
			;			taruj()
		Case $Cofnij_button
			;			cofnij($adres_skryptu, $id_wagi)
		Case $Wyslij_button
			;			wyslij($adres_skryptu, $id_wagi, $dane)
	EndSwitch
WEnd

Func wypisz_stan_wagi()
	GUICtrlSetData($work_status_label, $WAGA & " " & $SIEC)
EndFunc   ;==>wypisz_stan_wagi

Func sprawdz_polaczenie_z_serwerem()
	$ping = Ping("10.185.40.31", 8000)
	If $ping Then
		$SIEC = $network_OK
		ConsoleWrite("Siec jest ok. Polaczono z serwerem")
	Else
		$SIEC = $network_BAD
		ConsoleWrite("Siec nie dziala. Brak polaczenia z serwerem. Sprawdz adres do ktorego pingujesz")
	EndIf
	wypisz_stan_wagi()
EndFunc   ;==>sprawdz_polaczenie_z_serwerem

Func kaz_wadze_pisac_nonstop()
	_CommSendString("C1" & @CRLF, 1)
EndFunc   ;==>kaz_wadze_pisac_nonstop

Func HttpPost($sURL, $sData = "")
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1", "MyErrFunc")

	$oHTTP.Open("POST", $sURL, False)
	If (@error) Then wyjdz(1, 0, 0)

	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$oHTTP.Send($sData)
	If (@error) Then Exit

	If ($oHTTP.Status <> $HTTP_STATUS_OK) Then
		wyjdz(3, 0, 0)
	Else
		GUICtrlSetData($work_status_label, "Wyslano: " & $sData)
	EndIf

EndFunc   ;==>HttpPost

Func wyjdz($wy1 = "", $wy2 = "", $wy3 = "")
	$log = FileOpen(@ScriptDir & "\" & $nazwa_wagi & ".txt", 1)
	FileWriteLine($log, @YEAR & ":" & @MDAY & ":" & @MON & ":" & @HOUR & ":" & @MIN & ">" & $ostatnie_dane_nadane)
	$SIEC = $network_BAD
	FileClose($log)
EndFunc   ;==>wyjdz

Func wyslij($sServerAddress, $numer_czujnika, $dane)
	$dane = StringStrip($dane)
	$Request = "nazwa=" & $numer_czujnika & "dane=" & $dane
	$ostanie_dane_nadane = $dane * (-1)
	HttpPost($sServerAddress, $Request)
EndFunc   ;==>wyslij

Func cofnij($sServerAddress, $numer_czujnika, $dane)
	$Request = "nazwa=" & $numer_czujnika & "dane=" & $dane
	HttpPost($sServerAddress, $Request)
EndFunc   ;==>cofnij

Func StringStrip($napis)
	$napis = StringStripWS(StringStripCR($napis), 8)
	$napis = StringReplace($napis, "s", "")
	$napis = StringReplace($napis, "g", "")
	$napis = StringReplace($napis, "i", "")
	If (IsNumber($napis)) Then
		$WAGA = $WORKING
	Else
		$WAGA = $NOT_WORKING
	EndIf
	ConsoleWrite(@CRLF & "String stripped = " & $napis)
	Return $napis
EndFunc   ;==>StringStrip

Func taruj()
	GUICtrlSetData($work_status_label, "Taruje")
	_CommSendString("T" & @CRLF, 1)
	kaz_wadze_pisac_nonstop()
	Sleep(1000) ;
	wypisz_stan_wagi()
	;_CommSendByte("T"&@CRLF,1)
EndFunc   ;==>taruj
