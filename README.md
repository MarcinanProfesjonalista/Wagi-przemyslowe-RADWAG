# Wagi-przemyslowe-RADWAG
To programy które będą obsługiwać komunikację Waga &lt;-> Komputer -> Serwer HMI 

![podstawowy interfejs uzytkownika](https://github.com/MarcinanBarbarzynca/Wagi-przemyslowe-RADWAG/blob/main/wersja%20stabilna%200.1/interfejs.png)

Zrobiłem program obsługujący ważenie dla pieców.
Teraz trzeba go przetestować (bo niemam w mieszkaniu jak). Po udanych testach będzie można po prostu iść i działać.  

## Opis działania:
Program obsługi wag składa się z dwóch elementów: menadżera okien który tylko uruchamia wagi i ustawia okna, oraz Interfejsu użytkownika który odpowiada za poprawne wysyłanie danych do serwera i wyświetlanie tego co się dzieje aktualnie na wadze (i programie)
## Menedżer okien:
Po uruchomieniu komputera Autorun uruchamia (BAT*) program zarządzający wagami. Program odczytuje plik w którym zawarte są ustawienia każdej podłączonej do komputera wagi. Program uruchamia interfejs dla każdej wagi osobno, oraz ustawia okna wyświetlające stan wagi na ekranie tak aby nie zasłaniały się nawzajem. 
Wyświetla błędy w przypadku niepoprawnego uruchomienia wagi.
## Interfejs użytkownika
* Łączy się z wagą. Jeżeli nie rozpoznaje wagi na porcie to daje znać. 
* Łączy się z serwerem. 
* Łączy się z ewentualnym pilotem na porcie COM 
* Wyświetla błędy w przypadku problemów z połączeniemWyświetla GUI z podaną wagą, stanem połączenia i przyciskami odpowiednio: Wyślij Taruj i Cofnij dla wag piecowaych, oraz Pauza ważenia, Taruj, Wznowienie ważenia, dla wag farb. 
 
### Działanie przycisków
* Wyślij --> Otwiera po cichu stronę internetową która łączy się z serwerem i zawiera dane logu do serwera. 
* Cofnij --> Wysyła ostatnio nadaną wagę wysłaną przy użyciu przycisku wyślij, ale odwraca jej wartość poprzez mnożenie * (-1)
* Taruj --> Przycisk taruj ma ukrytą funkcję: Resetuje ustawienia wagi, tak aby rozmawiała z komputerem i taruje wagę. 
Waga do farby wysyła do serwera dane co 20 sekund. Dla tych wag operator będzie miał klawiature i myszkę. 
* Pauza ważenia --> Zatrzymuje logowanie do serwera na czas manipulowania wiadrami farby
* Wznowienie ważenia --> Wznawia logowanie do serwera w momencie w którym operator uzna że można już zżucać dane do serwera. 

### Zanik połączenia
Dane których nie uda się wysłać na serwer zostaną wrzucone do pliku ze skryptem pod postacią logu z danej wagi (@TODAY : DATA)
Dzięki temu serwisant będzie mógł nadać ręcznie te odczyty.

Dla wag piecowych powstaną piloty z dwoma lub trzema przyciskami. Piloty będą zawierać w sobie mikrokontrolery które też będą podłączone za pomocą portu usb do komputera. Jeżeli w pliku ustawień wagi będzie określony pilot to zostanie on automatycznie przypisany do danej wagi. 

Najważniejsze aby umieścić wagi w portach USB, a potem dobrze edytować plik ustawień wag. 

# TAK, Wagi są wpięte do portów USB komputera. 10m kabla usb to nie problem. Mikrokontrolerów użyje tylko jeżeli nie będzie się dało zrobić inaczej. 

Słownik: BAT - https://pl.wikipedia.org/wiki/Program_wsadowy --> Jest to skrypt który kopiujemy do folderu autorun który odpala sekwencję programów exe. Port COM --> Jest to kontroler portu USB. Na obudowie komputera mamy takie porty usb, czasami rs232. GUI -->Okienko windows z przyciskami. UI --> User interface
