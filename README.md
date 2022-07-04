# <img align="left" src="/repoAssets/nanotool.png" width="100" alt="Nanotool logo"> Nanotool
A nano-sized weather station based on a Raspberry Pi with an API and an iOS app.

## Tehnologii

###  Built-in API
<img align="left" src="/repoAssets/nanotoolAPI.png" width="50" alt="Nanotool logo"> Nanotool are un API built-in scris cu ajutorul Flask (Python).<br/>Acesta usureaza comunicarea cu statia meteo, dar si crearea unor accesorii ce folosesc acest API.<br/>
###### Cititi mai multe informatii despre software si API [aici](/software/info.md).

###  iOS & Mac Catalyst App
<img align="left" src="/repoAssets/nanotoolApp.png" width="50" alt="Nanotool logo"> Stația meteo Nanotool dispune de o aplicație care foloseste API-ul pentru a comunica cu aceasta.<br/>Aplicatia afișează date live ale vremii, cât și un istoric pe zile. Acestea sunt dispuse sub forma de grafice.<br/>
###### Cititi mai multe informatii despre aplicatie [aici](/app/info.md).

###  Senzori
<img align="left" src="/repoAssets/nanotoolSensors.png" width="50" alt="Nanotool logo">Stația include mulți senzori ce permit monitorizarea vremii. Datele acestora sunt înregistrate zilnic într-un spreadsheet .csv, ce poate fi accesat prin API sub formă de JSON / descărcat.<br/></br>Senzorii folosiți sunt:
   - <b>Anemometru</b> - măsoară viteza vântului 
   - <b>Pluviometru</b> - măsoară cantitatea de apă provenită de la ploaie într-un interval de timp dat
   - <b>BMP280</b> - măsoară temperatura și presiunea barometrică a aerului
   - <b>DHT11</B> - măsoară umiditatea aerului
   - <b>Raspberry Pi Camera Module v2</b> - folosind OpenCV, detectează prezența norilor pe cer sau venirea nopții
