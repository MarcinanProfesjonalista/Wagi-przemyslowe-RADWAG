# Wagi-przemyslowe-RADWAG
To programy które będą obsługiwać komunikację Waga &lt;-> Komputer -> Serwer HMI 

Zrobiłem już program obsługujący ważenie dla pieców.
Teraz trzeba go przetestować (bo niemam w mieszkaniu jak). Po udanych testach będzie można po prostu iść i działać.  

# Opis działania:
Program obsługi wag składa się z dwóch elementów: menadżera okien który tylko uruchamia wagi i ustawia okna, oraz Interfejsu użytkownika który odpowiada za poprawne wysyłanie danych do serwera i wyświetlanie tego co się dzieje aktualnie na wadze (i programie)
# Menedżer okien:
Po uruchomieniu komputera Autorun uruchamia (BAT*) program zarządzający wagami.Program odczytuje plik w którym zawarte są ustawienia każdej podłączonej do komputera wagi.Program uruchamia interfejs dla każdej wagi osobno, oraz ustawia okna wyświetlające stan wagi na ekranie tak aby nie zasłaniały się nawzajem. 
Wyświetla błędy w przypadku niepoprawnego uruchomienia wagi.
# Interfejs użytkownika
Łączy się z wagą. Jeżeli nie rozpoznaje wagi na porcie to daje znać. 
Łączy się z serwerem. 
Łączy się z ewentualnym pilotem na porcie COM 
Wyświetla błędy w przypadku problemów z połączeniemWyświetla GUI z podaną wagą, stanem połączenia i przyciskami odpowiednio: Wyślij Taruj i Cofnij dla wag piecowaych, oraz Pauza ważenia, Taruj, Wznowienie ważenia, dla wag farb. 
Przycisk taruj ma ukrytą funkcję: Resetuje ustawienia wagi, tak aby rozmawiała z komputerem i taruje wagę. 
Waga do farby wysyła do serwera dane co 20 sekund. Dla tych wag operator będzie miał klawiature i myszkę. 

Dla wag piecowych powstaną piloty z dwoma lub trzema przyciskami. Piloty będą zawierać w sobie mikrokontrolery które też będą podłączone za pomocą portu usb do komputera. Jeżeli w pliku ustawień wagi będzie określony pilot to zostanie on automatycznie przypisany do danej wagi. 

Najważniejsze aby umieścić wagi w portach USB, a potem dobrze edytować plik ustawień wag. 

Słownik: BAT - https://pl.wikipedia.org/wiki/Program_wsadowy --> Jest to skrypt który kopiujemy do folderu autorun który odpala sekwencję programów exe. Port COM --> Jest to kontroler portu USB. Na obudowie komputera mamy takie porty usb, czasami rs232. GUI -->Okienko windows z przyciskami. UI --> User interface
