# Nanotool Raspberry Pi Software

Acest folder contine codul sursa al statiei meteo, scris pentru Raspberry Pi.
De asemenea, acest folder contine si un makefile ce poate fi folosit pentru a instala acest software cu usurinta pe hardware, precum si dependency-urile acestuia.

# Description
Nanotool rulează la boot un script Python, ce efectuează măsurătorile cu ajutorul senzorilor și pornește server-ul web API, realizat cu ajutorul Flask. Acesta conține mai multe thread-uri dedicate fiecărui senzor și activitate (precum salvarea datelor la un interval de timp). 

# Install
Installer-ul necesita o conexiune activa la internet si privilegii root.

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
Este recomandata crearea unui user cu privilegii inferioare unui user de tip sudo, care sa aiba doar atribuțiile necesare pentru a rula API-ul.
API-ul, scris in Flask, rulează cu setările de production (nu de development).

# Legal
Raspberry Pi este o marcă a Raspberry Pi Ltd.
