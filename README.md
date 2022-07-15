# <img align="left" src="/repoAssets/nanotool.png" width="100" alt="Nanotool logo"> Nanotool
A nano-sized weather station based on a Raspberry Pi with an API, iOS & Mac Catalyst app, and sensor-based automations.

# <img src="/repoAssets/nanotoolAppPosterImage.png" alt="Nanotool App Banner">

## Descriere
Vremea este deseori instabilă și imprevizibilă. În plus, în multe locații nu se află stații meteo în apropiere, așa că prognoza pentru aceste zone nu este întocmai corectă. Multe acțiuni ale noastre depind de vreme, de la cum ne îmbrăcăm, până la udarea florilor. Cert este că trebuie să fim bine informați despre aceasta. Stația meteo Nanotool rezolvă aceste probleme.<br/>

Nanotool este o stație meteo ce are la bază un Raspberry Pi 4B. Aceasta are conectați mai mulți senzori ce monitorizează condițiile atmosferice, și dispune de un API ce facilitează comunicarea cu aceasta. Controlul stației este ușurat de aplicația pentru iPhone, iPad și Mac.

Pentru a o înțelege cât mai bine, vremea trebuie monitorizată. Stația monitorizează zilnic vremea (mai precis, viteza si directia vantului, cantitatea de ploaie, temperatura, presiunea și umiditatea aerului) și înregistrează datele. Acestea pot fi vizualizate sub formă de grafic în orice moment, folosind aplicația stației.<br/>

Uneori este necesar un răspuns instant la acțiunea vremii, însă cand suntem la distantă de casă, nu putem face nimic, cum ar fi pornitul / opritul unui furtun cu apă ce udă plantele, sau controlul jaluzelelor. Nanotool poate controla dispozitive externe automat, cu ajutorul a 4 relee și al API-ului ce ușurează configurarea acestor automatizări.<br/>

## Tehnologii
Nanotool folosește un Raspberry Pi 4B (4GB RAM) cu Raspberry Pi OS Lite (Bullseye, 64-bit). La boot, aceasta rulează un script Python ce salvează zilnic datele înregistrate de senzori. Acesta conține și server-ul web API, care este folosit de aplicație pentru comunicarea cu stația meteo.

###  Built-in API
<img align="left" src="/repoAssets/nanotoolAPI.png" width="50" alt="Nanotool logo"> Nanotool are un API built-in scris cu ajutorul Flask (Python).<br/>Acesta usureaza comunicarea cu statia meteo, dar si crearea unor accesorii ce folosesc acest API. API-ul trimite raspunsuri JSON la request-uri de tip GET / POST, sau fișiere CSV atunci când datele înregistrate de senzori din zilele precedente sunt descărcate.</br>
###### Cititi mai multe informatii despre software si API [aici](/software/info.md).

###  iOS & Mac Catalyst App
<img align="left" src="/repoAssets/nanotoolApp.png" width="50" alt="Nanotool logo"> Nanotool dispune de o aplicație realizată cu ajutorul SwiftUI. Aceasta foloseste API-ul pentru a comunica cu stația.<br/>Aplicatia afișează date live ale vremii, cât și un istoric pe zile. Acestea sunt dispuse sub formă de grafice.<br/>
###### Cititi mai multe informatii despre aplicatie [aici](/app/info.md).

### Sarcini automatizate (“Automated Tasks”)
<img align="left" src="/repoAssets/nanotoolAuto.png" width="50" alt="Nanotool Automated Tasks logo"> Sarcinile automatizate oferă un răspuns instant la acțiunea vremii. Când o anumită condiție este respectată pentru un anumit timp (valoarea înregistrată de un senzor atinge un anumit prag), atunci poate fi pornit / oprit unul dintre cele 4 relee controlate de Nanotool. Automatizările pot fi configurate cu ușurință prin API și aplicație. Astfel, Nanotool ușurează și facilitează automatizarea unor acțiuni precum udatul florilor, închiderea jaluzelelor, pornirea luminilor, sau pornirea unui sistem de încălzire / răcire.

Folosind aceste relee, se pot creea 2 tipuri de accesorii:
   - <b>Simple</b> - releele acționează pe post de întrerupător într-un circuit electric simplu
   - <b>Inteligente</b> - releele acționează pe post de întrerupător conectat la un microcontroller (de exemplu: Raspberry Pi Pico, Arduino, ESP, ATTINY85). în general, aceste accesorii pot realiza de acțiuni mai complexe.
   
Pentru automatizări au fost alese relee în loc de tranzistori, deoarece conferă un plus de siguranță prin separarea circuitelor.
Pe lângă aceste accesorii controlate de relee, se pot crea altele care să folosească API-ul pentru a verifica singure datele înregistrate de senzori.

###  Senzori
<img align="left" src="/repoAssets/nanotoolSensors.png" width="50" alt="Nanotool logo">Stația include mulți senzori ce permit monitorizarea vremii. Datele acestora sunt înregistrate zilnic într-un spreadsheet .csv, ce poate fi accesat prin API sub formă de JSON / descărcat.<br/></br>Senzorii folosiți sunt:
   - <b>Anemometru</b> - măsoară viteza vântului folosind un întrerupător magnetic reed. La fiecare rotație, un magnet trece pe deasupra întrerupătorului, iar rotația este înregistrată de Pi.
   - <b>Giruetă</b> - măsoară direcția vântului 
   - <b>Pluviometru</b> - măsoară cantitatea de apă provenită de la ploaie (l/m^2 = mm) într-un interval de timp dat. Acesta folosește tot un întrerupător magnetic reed.
   - <b>BMP280</b> - măsoară temperatura și presiunea barometrică a aerului
   - <b>DHT11</B> - măsoară umiditatea aerului
   - <b>Raspberry Pi Camera Module v2</b> - folosind OpenCV, detectează prezența norilor pe cer sau venirea nopții

Senzorii custom-made (Anemometru, Giruetă și Pluviometru), cât și camera, trebuie calibrate pentru a oferi rezultate precise. 

### Internet, Conectivitate & Setări
<img align="left" src="/repoAssets/nanotoolConnect.png" width="50" alt="Nanotool Connectivity logo"> Stația meteo Nanotool poate fi controlată prin conectarea la aceiași rețea de internet (Wi-Fi / Ethernet) a dispozitivelor. </br> API-ul poate fi folosit pentru controlarea setărilor scriptului Python. Pe lângă API, există și alte modalități prin care setările interne ale sistemului de operare pot fi modificate: 
   - folosind Raspberry Pi Imager la momentul instalării OS-ului
   - prin controlul direct al plăcii folosind o tastatură și un display (placa poate fi scoasă din cutie cu ușurință pentru a o conecta la un display)
   - prin SSH

### Design-ul Produsului & Sustenabilitate - Materiale reciclate
Stația este realizată cu materiale reciclate, provenite din obiecte precum becuri, jucării, ambalaje de alimente, hard disk-uri electronice și electroncasnice uzate. Acestea puteau să ajungă într-un coș de gunoi, însă soarta lor a fost schimbată de Nanotool.

Design-ul Nanotool este unul modern, simplist și modular, bazat pe elemente transparente ce expun componentele mecanice ale senzorilor custom-made, și cele electronice ale unității centrale. Chiar dacă este în mare parte realizat cu materiale reciclate, Nanotool se ridică la standardele industriale, dovedind o rigiditate sporită și rezistență la factorii de mediu, având și o eficiență sporită din punct de vedere termic.

### Display-ul LCD & Librăria CharPi
Toate valorile importante înregistrate de senzori sunt afișate pe display-ul Hitachi HD44780 cu backpack I²C de 80 de caractere. Acesta are rata de refresh adaptivă, informațiile fiind actualizate pe display doar atunci când este nevoie. Pentru comunicarea cu acesta, Nanotool folosește librăria CharPi, realizată tot de creatorul stației Nanotool.

### I2C
Multe dintre componentele utilizate de Nanotool folosesc I2C pentru a comunica cu Raspberry Pi-ul:
   - <b>LCD 20x4 HD44780</b> - display de 80 caractere
   - <b>BMP280</b> - senzor de temperatură și presiune
   - <b>ADS1115</b> - convertor Analog la Digital (ADC), folosit la giruetă

## Dependency-uri
### Software pentru Raspberry Pi
Software-ul ce rulează pe Raspberry Pi a fost realizat în Python 3.</br>Următoarele module non-native Python au fost folosite pentru software:
   - <b>CharPi</b> (librărie realizată de creatorul Nanotool) - folosit pentru comunicarea cu LCD-ul HD44780 prin I2C
   - <b>Flask</b> - folosit pentru crearea server-ului web API
   - <b>waitress</b> - folosit pentru host-ul server-ului web atunci când API-ul trebuie să ruleze cu setările de production (nu de development)
   - <b>adafruit_dht</b> - folosit pentru comunicarea cu senzorul DHT11
   - <b>adafruit_ads1x15</b> - folosit pentru comunicarea cu convertorul analogic la digital (ADS1115)
   - <b>adafruit_bmp280</b> - folosit pentru comunicarea cu senzorul BMP280
   - <b>board, busio</b> - dependency-uri pentru comunicarea cu anumiți senzori ce folosesc librăriile Adafruit CircuitPython
   - <b>OpenCV</b> - folosit pentru analiza imaginilor capturate de cameră
   - <b>picamera2</b> - folosit pentru comunicarea cu Raspberry Pi Camera Module v2
   - <b>RPi.GPIO</b> - folosit pentru controlul pinilor GPIO
   - <b>gpiozero</b> - folosit pentru a citi temperatura CPU (sau se poate folosi modulul os astfel: os.popen("vcgencmd measure_temp").read())
   
### Aplicația iOS & Mac Catalyst
Aplicația a fost realizată în întregime folosind limbajul Swift.
Au fost folosite următoarele framework-uri <i>native</i> ale iOS SDK:
   - <b>SwiftUI</b> - folosit pentru UI
   - <b>WidgetKit</b> - folosit pentru crearea widget-urilor pentru Home Screen și Today View pe dispozitivele iOS.
   - <b>Intents & IntentsUI</b> - folosit pentru configurarea widget-urilor de pe Home Screen-ul device-urilor iOS.

## License
Imaginile din acest repo nu se supun condiților din licența codului open-source.
Folosirea imaginilor in orice scop fără aprobarea creatorului acestui repo, cu excepția în care legislația permite acest lucru, este interzisă.

Licența poate fi accesată [aici](/LICENSE).

## Legal
iPhone, iPad, iPadOS, Mac și Mac Catalyst sunt mărci comerciale ale Apple Inc., înregistrate în S.U.A. și în alte țări și regiuni.<br/> IOS este o marcă comercială sau o marcă comercială înregistrată a Cisco, în S.U.A. și în alte țări.<br/>Raspberry Pi este o marcă a Raspberry Pi Ltd.
