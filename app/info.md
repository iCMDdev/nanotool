# <img align="left" src="/repoAssets/nanotoolApp.png" width="100" alt="Nanotool logo"> Nanotool iOS & Mac Catalyst App
Acest folder contine aplicatia Nanotool pentru iPhone, iPad si Mac, sub forma unui proiect Xcode. 

<img  src="/repoAssets/nanotoolAppPosterImage.png" alt="Nanotool App Banner">

<img align="left" src="/repoAssets/widgetTemp.png" width="300" alt="Nanotool logo"> Aplicația este realizată în întregime in Swift. Aceasta foloseste SwiftUI și este compusă din mai multe View-uri (pentru senzori, relee, setări și automatizări), precum și modele (pentru date, grafice si automatizări). Totodată, am creat widget-uri (.systemMedium și .systemLarge) cu datele înregistrate de un anumit senzor în ziua respectivă dispuse sub formă de grafic, folosind WidgetKit și Intents.

Aplicația respectă regulile de thread concurrency ce vor fi aplicate începând cu Swift 6. Comunicarea cu API-ul se face prin functii asincronizate async / await, find astfel foarte responsive si neavând delay-uri.

# Requirements
Aplicația necesită iOS 15.0 sau o versiune mai recentă, respectiv macOS 12 Monterey sau o versiune mai recentă. Totodată, este necesară ultima versiune de Xcode 13 pentru build-ul aplicației și instalarea acesteia pe un dispozitiv.

Pentru instalarea aplicației pe un dispozitiv, codul trebuie semnat folosind Xcode / codesign. Astfel, trebuie selectat un development team în Signing & Capabilities editor. Este necesar un cont de Apple Developer (nu neapărat participant Apple Developer Program).

# Legal
iPhone, iPad, Mac, Mac Catalyst și Xcode sunt mărci comerciale ale Apple Inc., înregistrate în S.U.A. și în alte țări și regiuni.
IOS este o marcă comercială sau o marcă comercială înregistrată a Cisco în S.U.A. și în alte țări.
