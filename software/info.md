# Nanotool Raspberry Pi software

Acest folder contine codul sursa al statiei meteo, scris pentru Raspberry Pi.
De asemenea, acest folder contine si un makefile ce poate fi folosit pentru a instala acest software cu usurinta pe hardware, precum si dependency-urile acestuia.

# Install
Descarcati installer-ul makefile de la [Releases](https://github.com/iCMDgithub/nanotool/releases) pe Raspberry Pi, apoi navigati spre locatia acestuia in filesystem folosind urmatoarea comanda in terminal:
```
cd Path_Spre_Makefile
```

Apoi, folositi comanda make in acel folder:
```
make
```
Nota: pentru a functiona, trebuie sa va asigurati ca nu mai aveti alte fisiere makefile in folder-ul in care se afla installer-ul.

Pentru a rula codul de fiecare data cand Nanotool este pornit, puteti folosi crontab. Daca este prima oara cand folositi aceasta comanda, va trebui sa selectati editorul de text dorit.
```
crontab -e
```
La finalul fisierului deschis in urma rulari comenzii de mai sus, adaugati urmatoarea linie de cod pentru rularea la (re)boot:
```
@reboot python3 ~/webapi.py
```
# Run
Pentru rularea software-ului, folositi comanda
```
python3 ~/webapi.py
```

# Securitatea API-ului
Este recomandata crearea unui user cu privilegii inferioare unui user de tip sudo, care sa aaiba doar atributiile necesare pentru a rula API-ul.
Makefile-ul seteaza automat o variabila de environment pentru ca API-ul, scris in Flask, sa ruleze cu setarile de production (nu de development).

# Legal
Raspberry Pi este o marcă a Raspberry Pi Ltd.
