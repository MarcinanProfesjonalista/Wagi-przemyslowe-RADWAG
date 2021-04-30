#include <Array.au3>
#include <MsgBoxConstants.au3>

	FileInstall(@ScriptDir & "\COMMG64.dll", @ScriptDir & "\COMMG64.dll")
	FileInstall(@ScriptDir & "\gui.au3", @ScriptDir & "\gui.au3")
	FileInstall(@ScriptDir & "\odpalacz_wagi.au3", @ScriptDir & "\odpalacz_wagi.au3")
	FileInstall(@ScriptDir & "\ustawienia_wag.txt", @ScriptDir & "\ustawienia_wag.txt")


wczytaj_dane_z_pliku()

Func wczytaj_dane_z_pliku()
	$preset = FileOpen("ustawienia_wag.txt", 0)
	$array = FileReadToArray($preset)
	$i = 0
	For $line In $array
		ConsoleWrite("[" & $i & "]" & $line & @CRLF)
		$i = $i + 1
	Next
	Global $adres_serwera = $array[_ArraySearch($array, "insert.php", 0, 0, 0, 1)]
	ConsoleWrite("Adres skryptu serwera: " & $adres_serwera & @CRLF)
	$index_od_ktorego_zaczyna_sie_lista_wag = _ArraySearch($array, "COM", 0, 0, 0, 1)
	ConsoleWrite("Index od którego zacznaja sie wagi: " & $index_od_ktorego_zaczyna_sie_lista_wag & @CRLF)

	For $i = $index_od_ktorego_zaczyna_sie_lista_wag + 1 To UBound($array) - 1
		$lista_po_splicie = StringSplit($array[$i],";")
		_ArrayDisplay($lista_po_splicie)
		sleep(100)
		$komenda = (@ScriptDir & '\odpalacz_wagi.exe "' &$adres_serwera&";"& $array[$i] & '"')
		sleep(100)
		ConsoleWrite("Run " & $komenda & @CRLF)
		if(WinExists($lista_po_splicie[1])<>1) Then
		run($komenda)
		EndIf
		ConsoleWrite($array[$i]& @CRLF)
		ConsoleWrite("Oczekuje na: "&$lista_po_splicie[1]& @CRLF)
		if(WinWaitActive($lista_po_splicie[1],"",3)) Then
		else
		MsgBox($MB_SYSTEMMODAL, "Ojej. Problem", "Nie udalo sie znalezc urzadzenia na porcie: " & $lista_po_splicie[4]& ".", 10)
		EndIf
		;$nazwa_wagi = StringLeft($array[$i],StringInStr($array[$i],";")-1)
		;ConsoleWrite($nazwa_wagi & @CRLF)
		;WinWaitActive($nazwa_wagi)
	Next
EndFunc   ;==>wczytaj_dane_z_pliku

