# <img align="left" src="/repoAssets/nanotool.png" width="100" alt="Nanotool logo"> Nanotool
A nano-sized weather station based on a Raspberry Pi with an API and an iOS & Mac Catalyst app.

## Descriere
Vremea este deseori instabilă și imprevizibilă. În plus, în multe locații nu se află stații meteo în apropiere, așa că prognoza pentru aceste zone nu este întocmai corectă. Multe acțiuni ale noastre depind de vreme, de la cum ne îmbrăcăm, până la udarea florilor. Cert este că trebuie să fim bine informați despre aceasta. Stația meteo nanotool rezolvă aceste probleme.<br/>

Nanotool este o stație meteo ce are la bază un Raspberry Pi 4GB. Aceasta are conectați mai mulți senzori ce o ajut să monitorizeze condițiile atmosferice.

Pentru a o înțelege cât mai bine, vremea trebuie monitorizată. Stația monitorizează zilnic vremea (mai precis, viteza si directia vantului, cantitatea de ploaie, temperatura, presiunea si umiditatea aerului) și înregistrează datele, pentru a putea fi vizualizate sub formă de grafic în orice moment.<br/>

Uneori este necesar un răspuns instant la acțiunea vremii, însă cand suntem la distantă de casă, nu putem face nimic, cum ar fi pornitul / opritul unui furtun cu apă ce udă plantele, sau controlul jaluzelelor. Nanotool poate controla dispozitive externe automat, cu ajutorul a 4 relee și al unui API ce ușurează configurarea acestor automatizări, precum și vizualizarea datelor înregistrate de senzori.<br/>

Controlul stației este ușurat de aplicația pentru iPhone, iPad și Mac.

## Tehnologii
Nanotool folosește un Raspberry Pi 4B (4GB RAM). Pe acesta rulează un script Python ce salvează zilnic datele înregistrate de senzori. Acesta conține și server-ul web (API), care este folosit de aplicația pentru iOS și Mac pentru comunicarea cu stația meteo.

###  Built-in API
<img align="left" src="/repoAssets/nanotoolAPI.png" width="50" alt="Nanotool logo"> Nanotool are un API built-in scris cu ajutorul Flask (Python).<br/>Acesta usureaza comunicarea cu statia meteo, dar si crearea unor accesorii ce folosesc acest API. API-ul trimite raspunsuri JSON la request-uri de tip GET / POST, sau fișiere CSV atunci când datele înregistrate de senzori din zilele precedente sunt descărcate.
###### Cititi mai multe informatii despre software si API [aici](/software/info.md).

###  iOS & Mac Catalyst App
<img align="left" src="/repoAssets/nanotoolApp.png" width="50" alt="Nanotool logo"> Stația meteo Nanotool dispune de o aplicație care foloseste API-ul pentru a comunica cu aceasta.<br/>Aplicatia afișează date live ale vremii, cât și un istoric pe zile. Acestea sunt dispuse sub formă de grafice.<br/>
###### Cititi mai multe informatii despre aplicatie [aici](/app/info.md).


###  Senzori
<img align="left" src="/repoAssets/nanotoolSensors.png" width="50" alt="Nanotool logo">Stația include mulți senzori ce permit monitorizarea vremii. Datele acestora sunt înregistrate zilnic într-un spreadsheet .csv, ce poate fi accesat prin API sub formă de JSON / descărcat.<br/></br>Senzorii folosiți sunt:
   - <b>Anemometru</b> - măsoară viteza vântului folosind un întrerupător magnetic reed. La fiecare rotație, un magnet trece pe deasupra întrerupătorului, iar rotația este înregistrată de Pi.
   - <b>Giruetă</b> - măsoară direcția vântului 
   - <b>Pluviometru</b> - măsoară cantitatea de apă provenită de la ploaie (l/m^2 = mm) într-un interval de timp dat. Acesta folosește tot un întrerupător magnetic reed.
   - <b>BMP280</b> - măsoară temperatura și presiunea barometrică a aerului
   - <b>DHT11</B> - măsoară umiditatea aerului
   - <b>Raspberry Pi Camera Module v2</b> - folosind OpenCV, detectează prezența norilor pe cer sau venirea nopții
   
### I2C
Multe dintre componentele utilizate de Nanotool folosesc I2C pentru a comunica cu Raspberry Pi-ul. Printre acestea se numără:
   - <b>LCD 20x4 HD44780</b> - display de 80 caractere
   - <b>BMP280</b> - senzor de temperatură și presiune
   - <b>ADS1115</b> - convertor Analog la Digital (ADC), folosit la giruetă
   
### Librăria CharPi
oate informațiile importante sunt afișate pe display-ul Hitachi HD44780 cu backpack I²C de 80 de caractere, folosind librăria CharPi pentru Python, realizată de mine.
