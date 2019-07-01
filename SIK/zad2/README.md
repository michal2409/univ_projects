<h2 dir="ltr">Wprowadzenie</h2><p dir="ltr">Zadanie polega na napisaniu sieciowej aplikacji rozproszonego przechowywania plików. Aplikacja składa się z węzłów serwerowych [zwanych w treści zadania także wymiennie serwerami] i węzłów klienckich [zwanych w treści zadania także wymiennie klientami]. Węzły serwerowe i klienckie komunikują się między sobą poprzez sieć zgodnie ze zdefiniowanym dalej protokołem. Węzły współpracują ze sobą, tworząc grupę węzłów. Grupa może składać się z dowolnej liczby węzłów. Węzły mogą dynamicznie dołączać do grupy lub odłączać się od grupy. Każdy węzeł udostępnia ten sam zestaw funkcjonalności danego typu (serwerowy lub kliencki) i wszystkie węzły dowolnego typu są sobie równe pod względem praw, priorytetów i możliwości w utworzonej grupie węzłów. Węzły klienckie dostarczają interfejs użytkownika pozwalający przede wszystkim na wysyłanie nowych plików do przechowywania w grupie, usuwanie ich lub pobieranie i poszukiwanie plików przechowywanych w grupie. Węzły serwerowe natomiast mają za zadanie przechowywać pliki.</p><h2 dir="ltr">Skrócona funkcjonalność aplikacji</h2><ul><li dir="ltr"><p dir="ltr">Każdy węzeł serwerowy udostępnia pewną zadaną przestrzeń pamięci nieulotnej.</p></li><li dir="ltr"><p dir="ltr">Węzły tworzą grupę dzięki wykorzystaniu tego samego adresu IP Multicast.</p></li><li dir="ltr"><p dir="ltr">Węzły serwerowe w jednej grupie umożliwiają przechowywanie dowolnej liczby plików o łącznym rozmiarze nieprzekraczającym łącznej przestrzeni dyskowej udostępnianej przez wszystkie węzły serwerowe w danej grupie.</p></li><li dir="ltr"><p dir="ltr">Łączna przestrzeń do przechowywania plików zmienia się dynamicznie wraz z dołączaniem i odłączaniem się węzłów serwerowych w grupie.</p></li><li dir="ltr"><p dir="ltr">Pliki przechowywane przez dowolny węzeł serwerowy widoczne są przez wszystkie węzły klienckie w danej grupie.</p></li><li dir="ltr"><p dir="ltr">Pliki przechowywane są niepodzielnie: jeden plik w całości przechowywany jest w pamięci nieulotnej węzła serwerowego.</p></li><li dir="ltr"><p dir="ltr">Pliki identyfikowane są po nazwie, a wielkość liter ma znaczenie.</p></li><li dir="ltr"><p dir="ltr">Każdy węzeł kliencki umożliwia dodanie nowego pliku do plików przechowywanych przez grupę lub usunięcie dowolnego istniejącego pliku.</p></li><li dir="ltr"><p dir="ltr">Każdy węzeł kliencki umożliwia pobranie zawartości dowolnego pliku z obecnie przechowywanych plików w grupie węzłów serwerowych</p></li><li dir="ltr"><p dir="ltr">Każdy węzeł kliencki umożliwia pobranie listy plików obecnie przechowywanych w grupie węzłów serwerowych.</p></li></ul><h2 dir="ltr">Protokół komunikacji między węzłami</h2><h5 dir="ltr">Format komunikatów</h5><p dir="ltr">Węzły do komunikacji między sobą używają protokołu UDP. Pakiety protokołu komunikacyjnego wymieniane pomiędzy węzłami mają postać:</p><pre><code>SIMPL_CMD<br></code><p dir="ltr"><code>&nbsp;&nbsp;&nbsp; char[10] cmd<br>&nbsp;&nbsp;&nbsp; uint64 cmd_seq<br>&nbsp;&nbsp;&nbsp; char[] data </code></p></pre><p></p><p dir="ltr">lub <br><br></p><p dir="ltr"></p><pre><code>CMPLX_CMD<br>&nbsp;&nbsp;&nbsp; char[10] cmd<br>&nbsp;&nbsp;&nbsp; uint64 cmd_seq<br>&nbsp;&nbsp;&nbsp; uint64 param<br>&nbsp;&nbsp;&nbsp; char[] data</code></pre><div><br></div><div>Wartości w polach <code>param</code> oraz <code>cmd_seq</code> powinny być przesyłane w sieciowej kolejności bajtów (ang. <i>big endian</i>).</div><p></p><p dir="ltr">W przypadku potrzeby przesłania wartości zmiennej o zadeklarowanej liczbie bitów mniejszej od 64, aplikacja powinna w pierwszej kolejności zrzutować wartość tej zmiennej na typ 64-bitowy a następnie przed wysłaniem wartości przez sieć odpowiednio przygotować kolejność bajtów przy użyciu funkcji <code>htobe64()</code>.</p><p></p><p dir="ltr">Jeśli wartość przesyłana w polu <code>cmd</code> jest krótsza niż 10 znaków, to zawartość pola <code>cmd</code> powinna zostać uzupełniona zerami.</p><h5 dir="ltr">W dalszej części specyfikacji używane są następujące oznaczenia:</h5><ul><li dir="ltr"><p dir="ltr">MCAST_ADDR – adres IP rozgłaszania (ang. <i>multicast</i>) ukierunkowanego używany przez wszystkie węzły jednej grupy;</p></li><li dir="ltr"><p dir="ltr">CMD_PORT – numer portu UDP, na którym węzły serwerowe danej grupy nasłuchują pakietów.</p></li></ul><p dir="ltr">Każdy z węzłów serwerowych powinien nasłuchiwać pakietów UDP na porcie CMD_PORT pod adresem rozgłoszeniowym MCAST_ADDR oraz swoim adresem jednostkowym (ang. <i>unicast</i>).</p><p dir="ltr">Wszystkie rozmiary plików i przestrzeni dyskowej wyrażane są w liczbie bajtów.</p><p dir="ltr">Serwer poznaje adres jednostkowy klienta na podstawie otrzymanego datagramu protokołu UDP.</p><h4 dir="ltr">Parowanie odpowiedzi serwera z zapytaniami klienta</h4><p dir="ltr">Klient przy wysyłaniu każdego zapytania do serwera powinien wypełnić zawartość pola <code>cmd_seq</code> unikalną wartością numeryczną umożliwiającą klientowi rozpoznawanie odpowiedzi serwera lub serwerów. Jeśli klient w trakcie swojego działania otrzyma pakiet danych, w którym wartość pola <code>cmd_seq</code> nie pokrywa się z wartością wysłaną i oczekiwaną w odpowiedzi, to klient powinien wypisać na standardowy strumień błędów jednoliniowy komunikat błędu o formacie określonym dalej w treści zadania.</p><p dir="ltr">Serwer w odpowiedzi powinien zawsze przepisać wartość pola <code>cmd_seq</code> z otrzymanego pakietu do pola o takiej samej nazwie w pakiecie z odpowiedzią.</p><p dir="ltr">Dalej w treści zadania pole <code>cmd_seq</code> nie będzie wspominane dla lepszej czytelności i przejrzystości, ale jest ono obligatoryjne we wszystkich wysyłanych pakietach.</p><h4 dir="ltr">Rozpoznawanie listy serwerów w grupie</h4><p dir="ltr">W celu poznania listy aktywnych węzłów serwerowych w grupie klient wysyła na adres rozgłoszeniowy MCAST_ADDR i port CMD_PORT pakiet <code>SIMPL_CMD</code> z poleceniem <code>cmd = “HELLO”</code> oraz pustą zawartością pola <code>data</code>.</p><p dir="ltr">Każdy z węzłów serwerowych po otrzymaniu powyższego pakietu powinien odpowiedzieć do nadawcy bezpośrednio na jego adres jednostkowy i port nadawcy pakietem <code>CMPLX_CMD</code> zawierającym:</p><ul><ul><li dir="ltr"><p dir="ltr">pole <code>cmd</code> z wartością <code>“GOOD_DAY”</code>;</p></li><li dir="ltr"><p dir="ltr">pole <code>param</code> z wartością wolnej przestrzeni dyskowej na przechowywanie plików;</p></li><li dir="ltr"><p dir="ltr">pole <code>data</code> z wartością tekstową zawierającą adres MCAST_ADDR, na jakim serwer nasłuchuje, w notacji kropkowej.</p></li></ul></ul><h5 dir="ltr"><br></h5><h5 dir="ltr">Przeglądanie listy plików i wyszukiwanie na serwerach w grupie</h5><p dir="ltr">W celu poznania listy wszystkich plików aktualnie przechowywanych w węzłach danej grupy klient wysyła na adres rozgłoszeniowy MCAST_ADDR i port CMD_PORT pakiet <code>SIMPL_CMD</code> z poleceniem <code>cmd = “LIST”</code> i pustą wartością pola <code>data</code>. </p><p dir="ltr">W celu odnalezienia w grupie plików zawierających w nazwie zadany ciąg znaków klient wysyła na adres rozgłoszeniowy MCAST_ADDR i port CMD_PORT pakiet <code>SIMPL_CMD</code> z poleceniem <code>cmd = “LIST”</code> oraz szukanym ciągiem znaków w polu <code>data</code>.</p><p dir="ltr">Każdy węzeł serwerowy po otrzymaniu jednego z powyższych pakietów powinien odpowiedzieć nadawcy bezpośrednio na jego adres jednostkowy i port nadawcy pakietem <code>SIMPL_CMD</code>:</p><ul><li dir="ltr"><p dir="ltr">Pole <code>cmd</code> z wartością <code>“MY_LIST”</code>.</p></li><li dir="ltr"><p dir="ltr">Pole <code>data</code> powinno zawierać listę nazw plików przechowywanych przez dany węzeł; nazwy plików powinien rozdzielać znak nowego wiersza (znakiem nowego wiersza jest <code>‘\n’</code>). Jeśli lista wszystkich nazw plików danego serwera spowodowałaby przekroczenie dopuszczalnego rozmiaru jednego pakietu danych UDP, to serwer powinien podzielić listę nazw swoich plików na odpowiednią liczbę pakietów, wysyłając wielokrotnie odpowiedź <code>“MY_LIST”</code> z kolejnymi nazwami plików, aż do wysłania całej listy. Zakładamy, że nie obsługujemy plików o nazwach przekraczających dopuszczalny rozmiar danych jednego pakietu UDP.</p></li></ul><br><p dir="ltr">Jeśli otrzymany przez serwer pakiet z <code>cmd = “LIST”</code> zawiera niepusty ciąg znaków w polu <code>data</code>, to serwer powinien w odpowiedzi przesłać tylko te nazwy plików, które zawierają ów niepusty ciąg znaków (wielkość liter ma znaczenia przy porównywaniu nazw plików). Jeśli żadna nazwa pliku nie zawiera poszukiwanego ciągu znaków, to serwer nie odpowiada żadnym pakietem do nadawcy na otrzymane zapytanie. Reakcja serwera będzie taka sama, jeśli nie przechowuje obecnie żadnego pliku.</p><h5><br></h5><h5 dir="ltr">Pobieranie pliku z serwera</h5><p dir="ltr">Dowolny węzeł kliencki ma prawo pobrać dowolny plik z dowolnego węzła serwerowego w danej grupie. Klient w celu rozpoczęcia pobierania konkretnego pliku wysyła do wybranego węzła serwerowego na jego adres jednostkowy i port CMD_PORT pakiet <code>SIMPL_CMD</code> z poleceniem <code>cmd = “GET”</code> oraz nazwą pliku w polu <code>data</code>.</p><br><p dir="ltr">Serwer po otrzymaniu powyższego komunikatu odpowiada nadawcy na jego adres jednostkowy i port nadawczy pakietem <code>CMPLX_CMD</code> zawierającymi:</p><ul><li dir="ltr"><p dir="ltr">pole <code>cmd = “CONNECT_ME”</code>;</p></li><li dir="ltr"><p dir="ltr">pole <code>param</code> z numerem portu TCP, na którym oczekuje połączenia od klienta;</p></li><li dir="ltr"><p dir="ltr">pole <code>data</code> z nazwą pliku, który zostanie wysłany.</p></li></ul><p dir="ltr">Jeśli serwer otrzyma pakiet z żądaniem pobrania pliku, którego serwer nie ma, to serwer nie odpowiada na taki pakiet, ale powinien odnotować otrzymanie niewłaściwego pakietu zgodnie ze specyfikacją opisaną w dalszej treści.</p><br><p dir="ltr">Klient po otrzymaniu powyższego komunikatu od serwera powinien nawiązać połączenie TCP z węzłem serwerowym, używając jego adresu jednostkowego oraz otrzymanego portu TCP. Serwer po nawiązaniu połączenia z klientem wysyła zawartość pliku i kończy połączenie.</p><br><h5 dir="ltr">Usuwanie pliku z serwera</h5><p dir="ltr">Dowolny węzeł kliencki ma prawo skasować dowolny plik z dowolnego węzła serwerowego w danej grupie. Klient w celu skasowania danego pliku z grupy wysyła na adres rozgłoszeniowy MCAST_ADDR (dozwolone jest wysłanie także na adres unicast wybranego serwera) i port CMD_PORT pakiet <code>SIMPL_CMD</code> z poleceniem <code>cmd = “DEL”</code> oraz z nazwą pliku do skasowania w polu <code>data</code>.</p><br><p dir="ltr">Każdy węzeł serwerowy po otrzymaniu powyższego komunikatu usuwa trwale plik wskazany nazwą, jeśli taki przechowuje.</p><br><h5 dir="ltr">Dodawanie pliku do grupy</h5><p dir="ltr">Klient w celu wysłania pliku do przechowywania go w grupie musi najpierw wyznaczyć węzeł, który będzie przechowywał ten plik. W tym celu może wykorzystać polecenie służące rozpoznawaniu serwerów w grupie opisane wcześniej (patrz opis dla <code>cmd = “HELLO”</code>).</p><br><p dir="ltr">Po wybraniu serwera klient komunikuje się z nim, wysyłając na jego adres jednostkowy oraz port CMD_PORT pakiet <code>CMPLX_CMD</code> zawierający:</p><ul><li dir="ltr"><p dir="ltr">pole <code>cmd = “ADD”</code>;</p></li><li dir="ltr"><p dir="ltr">pole <code>param</code> z rozmiarem pliku;</p></li><li dir="ltr"><p dir="ltr">pole <code>data</code> z nazwą pliku, który zostanie wysłany.</p></li></ul><br><p dir="ltr">Węzeł serwerowy po otrzymaniu powyższego komunikatu musi odpowiedzieć klientowi w zależności od aktualnej możliwości przyjęcia pliku. Jeśli serwer nie ma już miejsca na przechowanie pliku o rozmiarze wskazanym przez klienta, to odpowiada klientowi, wysyłając na jego adres jednostkowy i port nadawcy pakiet <code>SIMPL_CMD</code> z <code>cmd = “NO_WAY”</code> oraz nazwą pliku, jaki klient chciał dodać w polu <code>data</code>. Jeśli serwer przechowuje już obecnie plik o wskazanej przez węzeł kliencki nazwie, to serwer także powinien odpowiedzieć klientowi, wysyłając na jego adres jednostkowy i port nadawcy pakiet <code>SIMPL_CMD</code> z <code>cmd = “NO_WAY”</code> oraz nazwą pliku, jaki klient chciał dodać w polu <code>data</code>. Serwer powinien odmówić przyjęcia pliku także w przypadku gdy otrzymana nazwa pliku jest pusta lub zawiera znak <code>'/’</code>, wysyłając na adres jednostkowy i port nadawcy pakiet <code>SIMPL_CMD</code> z <code>cmd = “NO_WAY”</code> oraz nazwą pliku, jaki klient chciał dodać, w polu <code>data</code>.</p><br><p dir="ltr">Jeśli natomiast serwer dysponuje obecnie wolnym miejscem pozwalającym przechować plik o rozmiarze wskazanym przez nadawcę, to odpowiada klientowi na jego adres jednostkowy i port nadawcy pakietem <code>CMPLX_CMD</code> zawierającym:</p><ul><ul><li dir="ltr"><p dir="ltr">pole <code>cmd</code> z wartością <code>“CAN_ADD”</code>;</p></li><li dir="ltr"><p dir="ltr">pole <code>param</code> z numerem portu TCP, na którym serwer oczekuje połączenia od klienta;</p></li><li dir="ltr"><p dir="ltr">pole <code>data</code> pozostaje puste.</p></li></ul></ul><p dir="ltr">Klient po otrzymaniu powyższego komunikatu powinien nawiązać połączenie TCP z węzłem serwerowym, używając jego adresu jednostkowego oraz otrzymanego portu TCP. Klient wysyła zawartość pliku, po czym powinien zakończyć połączenie.</p><h2 dir="ltr">Część A - Węzeł serwerowy</h2><p dir="ltr">Zadanie polega na napisaniu programu implementującego zachowanie węzła serwerowego. Program powinien przyjmować następujące parametry linii poleceń:</p><ul><li dir="ltr"><p dir="ltr">MCAST_ADDR – adres rozgłaszania ukierunkowanego, ustawiany obowiązkowym parametrem <code>-g</code> węzła serwerowego;</p></li><li dir="ltr"><p dir="ltr">CMD_PORT – port UDP używany do przesyłania i odbierania poleceń, ustawiany obowiązkowym parametrem <code>-p</code> węzła serwerowego;</p></li><li dir="ltr"><p dir="ltr">MAX_SPACE – maksymalna liczba bajtów udostępnianej przestrzeni dyskowej na pliki grupy przez ten węzeł serwerowy, ustawiana opcjonalnym parametrem <code>-b</code> węzła serwerowego, wartość domyślna 52428800;</p></li><li dir="ltr"><p dir="ltr">SHRD_FLDR – ścieżka do dedykowanego folderu dyskowego, gdzie mają być przechowywane pliki, ustawiany parametrem obowiązkowym <code>-f</code> węzła serwerowego;</p></li></ul><ul><li dir="ltr"><p dir="ltr">TIMEOUT – liczba sekund, jakie serwer może maksymalnie oczekiwać na połączenia od klientów, ustawiane opcjonalnym parametrem <code>-t</code> węzła serwerowego, wartość domyślna 5, wartość maksymalna 300.</p></li></ul><p dir="ltr">&nbsp;&nbsp;&nbsp; </p><p dir="ltr">Serwer podczas uruchomienia powinien zindeksować wszystkie pliki znajdujące się bezpośrednio w folderze SHRD_FLDR, a ich łączny rozmiar liczony w bajtach odjąć od parametru MAX_SPACE. Serwer nie indeksuje plików w podkatalogach folderu SHRD_FLDR.</p><br><p dir="ltr">Serwer powinien podłączyć się do grupy rozgłaszania ukierunkowanego pod wskazanym adresem MCAST_ADDR. Serwer powinien nasłuchiwać na porcie CMD_PORT poleceń otrzymanych z sieci protokołem UDP także na swoim adresie unicast. Serwer powinien reagować na pakiety UDP zgodnie z protokołem opisanym wcześniej.</p><br><p dir="ltr">Jeśli serwer otrzyma polecenie dodania pliku lub pobrania pliku, to powinien otworzyć nowe gniazdo TCP na losowym wolnym porcie przydzielonym przez system operacyjny i port ten przekazać w odpowiedzi węzłowi klienckiemu. Serwer oczekuje maksymalnie TIMEOUT sekund na nawiązanie połączenia przez klienta i jeśli takie nie nastąpi, to port TCP powinien zostać niezwłocznie zamknięty. Serwer w czasie oczekiwania na podłączenie się klienta i podczas przesyłania pliku powinien obsługiwać także inne zapytania od klientów.</p><br><p dir="ltr">Jeśli serwer otrzyma polecenia dodania pliku, to odpowiedź klientowi pakietem <code>“CAN_ADD”</code> oznacza jednocześnie zarezerwowanie miejsca na serwerze niezbędnego do przyjęcia pliku od klienta.</p><br><p dir="ltr">Jakiekolwiek pakiety otrzymane przez program niezgodne ze specyfikacją protokołu powinny być pomijane przez serwer. Informacja o niewłaściwym pakiecie powinna zostać wypisana na standardowe wyjście błędów, &nbsp;jednolinijkowy komunikat o błędzie dla każdego niepoprawnego pakietu. Informacja o błędzie powinna zawierać informację w formacie:</p><br><p dir="ltr"></p><pre><code>[PCKG ERROR] Skipping invalid package from {IP_NADAWCY}:{PORT_NADAWCY}.</code></pre><p></p><p dir="ltr">gdzie <code>{IP_NADAWCY}</code> jest adresem IP nadawcy otrzymanego datagramu UDP<br>a <code>{PORT_NADAWCY}</code> jest numerem portu nadawcy datagramu UDP</p><p dir="ltr">Autor programu powinien uzupełnić wiadomość po kropce o dodatkowe informacje opisujące błąd, ale bez użycia znaku nowej linii.</p><br><p dir="ltr">Serwer powinien zakończyć swoje działanie łagodnie, to znaczy kończąc otwarte połączenia oraz zwalniając pobrane zasoby systemowe, po otrzymaniu sygnału <code>CTRL+C</code>. </p><h2 dir="ltr">Część B - Węzeł kliencki</h2><p dir="ltr">Zadanie polega na napisaniu programu implementującego zachowanie węzła klienckiego. Program powinien przyjmować następujące parametry linii poleceń:</p><ul><li dir="ltr"><p dir="ltr">MCAST_ADDR – adres rozgłaszania ukierunkowanego (może być także adresem broadcast), ustawiany obowiązkowym parametrem <code>-g</code>; klient powinien używać tego adresu do wysyłania komunikatów do grupy węzłów serwerowych;</p></li><li dir="ltr"><p dir="ltr">CMD_PORT – port UDP, na którym nasłuchują węzły serwerowe, ustawiany obowiązkowym parametrem <code>-p</code>; klient powinien używać tego numeru portu, aby wysyłać komunikaty do węzłów serwerowych;</p></li><li dir="ltr"><p dir="ltr">OUT_FLDR – ścieżka do folderu dyskowego, gdzie klient będzie zapisywał pobrane pliki, ustawiany parametrem obowiązkowym <code>-o</code>;</p></li></ul><ul><li dir="ltr"><p dir="ltr">TIMEOUT – czas oczekiwania na zbieranie informacji od węzłów wyrażony w sekundach; akceptowana wartość powinna być dodatnia i większa od zera; wartość domyślna 5; wartość maksymalna 300; może zostać zmieniona przez opcjonalny parametr <code>-t</code>.</p></li></ul><p dir="ltr">&nbsp;&nbsp;&nbsp; </p><p dir="ltr">Klient po rozpoczęciu swojej pracy powinien oczekiwać na polecenia użytkownika na standardowym wejściu. Każde polecenie kończy się znakiem nowej linii <code>'\n'</code>. Rozpoznawane przez program kliencki polecenia użytkownika (wielkość liter nie ma znaczenia):</p><ul><li dir="ltr"><p dir="ltr"><code>discover</code> – po otrzymaniu tego polecenia klient powinien wypisać na standardowe wyjście listę wszystkich węzłów serwerowych dostępnych aktualnie w grupie. Klient oczekuje na zgłoszenia serwerów przez TIMEOUT sekund, w trakcie oczekiwania interfejs użytkownika zostaje wstrzymany. Dla każdego odnalezionego serwera klient powinien wypisać na standardowe wyjście w jednej linii adres jednostkowy IP tego serwera, następnie w nawiasie adres MCAST_ADDR otrzymany od danego serwera, a na końcu rozmiar dostępnej przestrzeni dyskowej na tym serwerze. Oczekiwany format takiej linii:</p></li></ul><p dir="ltr"></p><pre><code>Found 10.1.1.28 (239.10.11.12) with free space 23456</code></pre><p></p><ul><li dir="ltr"><p dir="ltr"><code>search %s</code> – klient powinien uznać polecenie za prawidłowe, także jeśli podany ciąg znaków <code>%s</code> jest pusty. Po otrzymaniu tego polecenia klient wysyła po sieci do węzłów serwerowych zapytanie w celu wyszukania plików zawierających ciąg znaków podany przez użytkownika (lub wszystkich plików jeśli ciąg znaków <code>%s</code> jest pusty), a następnie przez TIMEOUT sekund nasłuchuje odpowiedzi od węzłów serwerowych. Otrzymane listy plików powinny zostać wypisane na standardowe wyjście po jednej linii na jeden plik. Każda linia powinna zawierać informację:<br><br></p><pre><code>{nazwa_pliku} ({ip_serwera})</code></pre><p dir="ltr">gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{nazwa_pliku}</code> to nazwa pliku otrzymana z serwera;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{ip_serwera}</code> to adres jednostkowy IP serwera, z którego dana nazwa pliku została przesłana.</p>Pakiety
 z odpowiedziami od serwerów z listą plików otrzymane po upływie TIMEOUT
 powinny zostać zignorowane przez klienta. Interfejs użytkownika zostaje
 wstrzymany na czas oczekiwania odpowiedzi z serwerów.<p></p></li></ul><ul><li dir="ltr"><p dir="ltr"><code>fetch %s</code> – użytkownik może wskazać nazwę pliku <code>%s</code>, tylko jeśli nazwa pliku występowała na liście otrzymanej w wyniku ostatniego wykonania polecenia search. W przeciwnym przypadku klient nie podejmuje akcji pobierania pliku, jednocześnie informując użytkownika o błędzie jednoliniowym komunikatem na standardowe wyjście. Jeśli wskazany plik istnieje w ostatnio wyszukiwanych, to klient powinien wybrać dowolny węzeł serwerowy, który przechowuje plik dokładnie wskazany przez podaną nazwę pliku <code>%s</code> i rozpocząć pobieranie pliku, zapisując plik do folderu OUT_FLDR. W trakcie pobierania pliku użytkownik powinien móc kontynuować korzystanie z programu. Po zakończeniu pobierania pliku klient powinien wypisać na standardowe wyjście komunikat o zakończeniu pobierania pliku w formacie:<br><br></p><pre><code>File {%s} downloaded ({ip_serwera}:{port_serwera})</code></pre><p dir="ltr">gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{ip_serwera}</code> to adres IP unicast serwera;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{port_serwera}</code> to port TCP serwera użyty do pobrania pliku.</p><p dir="ltr">Jeśli pobieranie pliku nie powiedzie się, to klient powinien wypisać na standardowe wyjście komunikat o błędzie w formacie:</p><pre><code>File {%s} downloading failed ({ip_serwera}:{port_serwera}) {opis_błędu}</code></pre><p dir="ltr">gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{ip_serwera}</code> to adres jednostkowy IP serwera;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{port_serwera}</code> to port TCP serwera użyty do pobrania pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{opis_błędu}</code> to komunikat słowny opisujący przyczynę błędu.</p><p></p></li></ul><ul><li dir="ltr"><p dir="ltr"><code>upload %s</code> – użytkownik powinien wskazać ścieżkę do pliku, który chce wysłać do przechowania w grupie. Użytkownik może podać pełną ścieżkę bezwzględną do pliku bądź ścieżkę względną. Jeśli użytkownik wskaże nazwę pliku poprzez ścieżkę względną, to należy rozpocząć szukanie pliku do wysłania w katalogu bieżącym. Jeśli wskazany plik nie istnieje, to klient powinien poinformować o tym fakcie użytkownika jednoliniową informacją o błędzie na standardowe wyjście w formacie<br><br></p><pre><code>File {%s} does not exist</code></pre>gdzie:<p dir="ltr">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku.<br></p><p dir="ltr">Klient
 powinien podjąć próbę wysłania pliku w pierwszej kolejności do węzła 
serwerowego o największej dostępnej wolnej przestrzeni. Jeśli żaden 
węzeł nie dysponuje wystarczającym wolnym miejscem, to klient powinien 
poinformować użytkownika o braku możliwości załadowania pliku, wypisując
 jednoliniową informację o błędzie na standardowe wyjście w formacie:<br></p><pre><code>File {%s} too big</code></pre><p dir="ltr">&nbsp;&nbsp;&nbsp; gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku.</p><p dir="ltr">W
 trakcie wysyłania pliku użytkownik powinien móc w dalszym ciągu 
korzystać z aplikacji. Po zakończeniu wysyłania pliku klient powinien 
wypisać na standardowe wyjście komunikat o zakończeniu wysyłania pliku w
 formacie:</p><pre><code>File {%s} uploaded ({ip_serwera}:{port_serwera})</code></pre><p dir="ltr">gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{ip_serwera}</code> to adres jednostkowy serwera;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{port_serwera}</code> to port TCP serwera użyty do pobrania pliku.</p><p dir="ltr">Jeśli wysyłanie pliku nie powiedzie się, to klient powinien wypisać na standardowe wyjście komunikat o błędzie w fomacie:</p><pre><code> File {%s} uploading failed ({ip_serwera}:{port_serwera}) {opis_błędu}</code></pre><p dir="ltr">gdzie:</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{%s}</code> to nazwa pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{ip_serwera}</code> to adres jednostkowy serwera</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{port_serwera}</code> to port TCP serwera użyty do pobrania pliku;</p><p dir="ltr">&nbsp;&nbsp;&nbsp; <code>{opis_błędu}</code> to komunikat słowny opisujący przyczynę błędu.</p><p></p></li></ul><ul><li dir="ltr"><p dir="ltr"><code>remove %s</code> – klient po otrzymaniu tego polecenia powinien wysłać do grupy serwerów zlecenie usunięcia wskazanego przez użytkownika pliku. Polecenie jest prawidłowe, tylko jeśli podana nazwa pliku <code>%s</code> jest niepusta.</p></li><li dir="ltr"><p dir="ltr"><code>exit</code> – klient po otrzymaniu tego polecenia powinien zakończyć wszystkie otwarte połączenia i zwolnić pobrane zasoby z systemu oraz zakończyć pracę aplikacji.</p></li></ul><br><p dir="ltr">Jakiekolwiek inne polecenia wpisane przez użytkownika powinny zostać uznane jako nieprawidłowe i zignorowane.</p><br><p dir="ltr">Jeśli klient w trakcie działania otrzyma pakiet sieciowy nie wynikający z opisanego protokołu (w szczególności także pakiet o nieoczekiwanej wartości pola <code>cmd_seq</code>), to powinien wypisać jednoliniową informację na standardowy strumień błędów o takiej samej postaci jak w przypadku serwera.<br></p><p dir="ltr"></p><pre><code>[PCKG ERROR] &nbsp;Skipping invalid package from {IP_NADAWCY}:{PORT_NADAWCY}.</code></pre><p></p><p dir="ltr">gdzie <code>{IP_NADAWCY}</code> jest adresem IP nadawcy otrzymanego datagramu UDP<br>a <code>{PORT_NADAWCY}</code> jest numerem portu nadawcy datagramu UDP</p><p dir="ltr">Autor programu powinien uzupełnić wiadomość po kropce o dodatkowe informacje opisujące błąd, ale bez użycia znaku nowej linii.</p><h2 dir="ltr">Część C - Węzły serwerowe zsynchronizowane</h2><p dir="ltr">Zadanie polega na opracowaniu rozwiązania poniżej zdefiniowanego problemu oraz zaimplementowaniu zaproponowanego rozwiązania w węźle serwerowym.</p><p dir="ltr">Opis zaproponowanego podejścia proszę umieścić w pliku tekstowym <code>readme.txt</code> przesłanego wraz z innymi plikami rozwiązania.</p><p dir="ltr">Problem dotyczy tylko węzłów serwerowych. Proszę zaprojektować protokół wymiany informacji pomiędzy serwerami zapewniający spójność przechowywanych plików w grupie węzłów. Lista warunków do spełnienia przez grupę węzłów serwerowych:</p><ul><li dir="ltr"><p dir="ltr">w grupie węzłów każdy plik o danej nazwie występuje tylko w jednej kopii przechowywanej przez dowolnie wybrany węzeł serwerowy;</p></li><li dir="ltr"><p dir="ltr">proponowane rozwiązanie powinno opierać się o protokół przedstawiony w treści niniejszego zadania;</p></li><li dir="ltr"><p dir="ltr">grupa składa się z dynamicznie dołączających i odłączających się węzłów serwerowych. Należy obsłużyć odpowiednio obie te sytuacje;</p></li><li dir="ltr"><p dir="ltr">serwer, który otrzymuje żądanie klienta z prośbą o przechowanie pliku, powinien swoim zachowaniem utrzymać spójność w grupie węzłów serwerowych tak aby dodawany plik nie naruszył założenia, że każdy przechowywany plik w grupie występuje tylko w jednej kopii.</p></li></ul><p dir="ltr">Implementację części C należy zrealizować wraz z częścią A w jednym programie. Jeśli program implementujący węzeł serwerowy realizuje także rozwiązanie części C, to program powinien obsługiwać dodatkowy parametr linii poleceń:</p><ul><li dir="ltr"><p dir="ltr">SYNCHRONIZED - przyjmujący wartość 0 lub 1, ustawiany opcjonalnym parametrem <code>-s</code> węzła serwerowego, wartość domyślna 0.</p></li></ul><p dir="ltr">Po ustawieniu powyższego parametru na wartość 1 węzeł serwerowy powinien rozpocząć pracę realizując zaproponowane rozwiązanie opisane w pliku <code>readme.txt</code>. Serwer z włączoną opcją SYNCHRONIZED powinien rozszerzać protokół opisany w treści niniejszego zadania, ale jego działanie nie będzie automatycznie testowane pod kątem spójności z protokołem opisanym wyżej.<br>Węzeł serwerowy z parametrem SYNCHRONIZED ustawionym na wartość 0 musi w pełni realizować implementację części A niniejszego zadania bez odstępstw, a jego działanie będzie traktowane jako rozwiązanie części A oraz między innymi testowane automatycznie pod kątem poprawności implementacji i zgodności ze zdefiniowanym protokołem.</p><h2 dir="ltr">Oddawanie rozwiązania</h2><p dir="ltr">Można oddać rozwiązanie tylko części A lub tylko części B, albo obu części. Część C można oddać tylko wraz z częścią A.<br></p><p dir="ltr">Rozwiązanie ma:</p><ul><li dir="ltr"><p dir="ltr">działać dla IPv4, w środowisku Linux, w laboratorium komputerowym;</p></li><li dir="ltr"><p dir="ltr">być napisane w języku C lub C++ z wykorzystaniem interfejsu gniazd (nie wolno korzystać z libevent ani boost::asio);</p></li><li dir="ltr"><p dir="ltr">kompilować się za pomocą GCC (polecenie gcc lub g++) – wśród parametrów należy użyć opcji -Wall, -Wextra i -O2, można korzystać ze standardów -std=c11, -std=c++11, -std=c++14, -std=c++17 (w zakresie wspieranym przez kompilator na maszynie students).</p></li></ul><p dir="ltr">Można korzystać z powszechnie znanych bibliotek pomocniczych (np.&nbsp;boost::program_options), o ile są zainstalowane na maszynie students oraz ich wykorzystanie nie stoi w sprzeczności z wyżej wymienionymi wymogami.</p><p dir="ltr">Jako rozwiązanie należy wysłać na moodla plik ab123456.tar.gz, gdzie ab123456 to login na students. W wysłanym pliku .tar.gz ma być katalog ab123456 zawierający pliki źródłowe i plik makefile. Nie wolno umieszczać tam plików binarnych ani&nbsp;pośrednich powstających podczas kompilacji.</p><p dir="ltr">W wyniku wykonania polecenia make dla części A (lub dla części A z C) zadania ma powstać plik wykonywalny netstore-server, a dla części B zadania – plik wykonywalny netstore-client.</p><p dir="ltr">Ponadto makefile powinien obsługiwać cel 'clean', który po wywołaniu kasuje wszystkie pliki powstałe podczas kompilacji.</p><h2 dir="ltr">Ocena</h2><p dir="ltr">Za rozwiązanie części A zadania można dostać maksymalnie 6 punktów.</p><p dir="ltr">Za rozwiązanie części B zadania można dostać maksymalnie 6 punktów.</p><p dir="ltr">Za rozwiązanie części C zadania można dostać maksymalnie 6 punktów.</p><p dir="ltr">Programy studentów muszą wykazywać pełną zgodność z powyżej opisaną specyfikacją. Nadesłane implementacje będą testowane z innymi serwerami i klientami oraz z implementacjami referencyjnymi części A oraz B. Implementacja rozwiązania części C musi być kompatybilna z serwerami i klientami implementującymi jedynie część A i B specyfikacji.</p><p dir="ltr">Ocena części A oraz B zadania będzie się składała z trzech składników:</p><ul><li dir="ltr"><p dir="ltr">ocena wzrokowa i manualna działania programu (30%);</p></li><li dir="ltr"><p dir="ltr">testy automatyczne (50%);</p></li><li dir="ltr"><p dir="ltr">jakość kodu źródłowego (20%).</p></li></ul><p dir="ltr">Ocena części C zadania będzie się składała ze składników:</p><ul><li dir="ltr"><p dir="ltr">ocena merytoryczna poprawności zaproponowanego rozwiązania opisanego w pliku readme.txt (50%);</p></li><li dir="ltr"><p dir="ltr">ocena wzrokowa i manualna działania programu (40%);</p></li><li dir="ltr"><p dir="ltr">jakość kodu źródłowego (10%).</p></li></ul><h2 dir="ltr">Termin</h2><p dir="ltr">Termin oddania zadania: niedziela <b><span class="" style="color: rgb(239, 69, 64);">2 czerwca 2019 godzina 23:59.</span></b> </p><p dir="ltr">Za każde rozpoczęte 12 godzin spóźnienia odejmujemy 3p. </p><p dir="ltr">Rozwiązanie dostarczone w I terminie można poprawić jednokrotnie w II terminie.</p><p dir="ltr">W II terminie nie odejmuje się punktów za spóźnienia. Rozwiązania z datą późniejszą niż 7&nbsp;dni przed egzaminem poprawkowym nie podlegają ocenie.</p></div></div>