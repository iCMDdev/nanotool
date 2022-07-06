# <img align="left" src="/repoAssets/nanotool.png" width="100" alt="Nanotool logo"> Nanotool
A nano-sized weather station based on a Raspberry Pi with an API and an iOS & Mac Catalyst app.

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
<img align="left" src="/repoAssets/nanotoolApp.png" width="50" alt="Nanotool logo"> Stația meteo Nanotool dispune de o aplicație care foloseste API-ul pentru a comunica cu aceasta.<br/>Aplicatia afișează date live ale vremii, cât și un istoric pe zile. Acestea sunt dispuse sub formă de grafice.<br/>
###### Cititi mai multe informatii despre aplicatie [aici](/app/info.md).

### Sarcini automatizate (“Automated Tasks”)
<img align="left" src="/repoAssets/nanotoolAuto.png" width="50" alt="Nanotool Automated Tasks logo"> Sarcinile automatizate oferă un răspuns instant la acțiunile vremii. Când o anumită condiție este respectată pentru un anumit timp (valoarea înregistrată de un senzor atinge o anumită valoare), atunci poate fi pornit / oprit unul dintre cele 4 relee. Sarcinile pot fi configurate cu usurinta prin API si aplicatie.

###  Senzori
<img align="left" src="/repoAssets/nanotoolSensors.png" width="50" alt="Nanotool logo">Stația include mulți senzori ce permit monitorizarea vremii. Datele acestora sunt înregistrate zilnic într-un spreadsheet .csv, ce poate fi accesat prin API sub formă de JSON / descărcat.<br/></br>Senzorii folosiți sunt:
   - <b>Anemometru</b> - măsoară viteza vântului folosind un întrerupător magnetic reed. La fiecare rotație, un magnet trece pe deasupra întrerupătorului, iar rotația este înregistrată de Pi.
   - <b>Giruetă</b> - măsoară direcția vântului 
   - <b>Pluviometru</b> - măsoară cantitatea de apă provenită de la ploaie (l/m^2 = mm) într-un interval de timp dat. Acesta folosește tot un întrerupător magnetic reed.
   - <b>BMP280</b> - măsoară temperatura și presiunea barometrică a aerului
   - <b>DHT11</B> - măsoară umiditatea aerului
   - <b>Raspberry Pi Camera Module v2</b> - folosind OpenCV, detectează prezența norilor pe cer sau venirea nopții

### Internet, Conectivitate & Setări
<img align="left" src="/repoAssets/nanotoolConnect.png" width="50" alt="Nanotool Connectivity logo"> Stația meteo Nanotool poate fi controlată prin conectarea la aceiași rețea de internet (Wi-Fi / Ethernet) a dispozitivelor. </br> API-ul poate fi folosit pentru controlarea setărilor scriptului Python. Pe lângă API, există și alte modalități prin care setările interne ale sistemului de operare pot fi modificate: 
   - folosind Raspberry Pi Imager la momentul instalării OS-ului
   - prin controlul direct al plăcii folosind o tastatură și un display (placa poate fi scoasă din cutie cu ușurință pentru a o conecta la un display)
   - prin SSH

### Display-ul LCD & librăria CharPi
Toate valorile importante înregistrate de senzori sunt afișate pe display-ul Hitachi HD44780 cu backpack I²C de 80 de caractere. Acesta are rata de refresh adaptivă, informațiile fiind actualizate pe display doar atunci când este nevoie. Pentru comunicarea cu acesta, Nanotool folosește librăria CharPi, realizată de mine.

### I2C
Multe dintre componentele utilizate de Nanotool folosesc I2C pentru a comunica cu Raspberry Pi-ul:
   - <b>LCD 20x4 HD44780</b> - display de 80 caractere
   - <b>BMP280</b> - senzor de temperatură și presiune
   - <b>ADS1115</b> - convertor Analog la Digital (ADC), folosit la giruetă
   
## Legal
iPhone, iPad, Mac și Mac Catalyst sunt mărci comerciale ale Apple Inc., înregistrate în S.U.A. și în alte țări și regiuni.<br/> IOS este o marcă comercială sau o marcă comercială înregistrată a Cisco în S.U.A. și în alte țări.<br/>Raspberry Pi este o marcă a Raspberry Pi Ltd.
