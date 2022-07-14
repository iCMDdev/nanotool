# <img align="left" src="/repoAssets/nanotoolApp.png" width="100" alt="Nanotool logo"> Nanotool iOS & Mac Catalyst App
Acest folder contine aplicatia Nanotool pentru iPhone, iPad si Mac, sub forma unui proiect Xcode. 

<img  src="/repoAssets/nanotoolAppPosterImage.png" alt="Nanotool App Banner">

Necesită ultima versiune de Xcode 13 pentru build-ul aplicației și instalarea acesteia pe un dispozitiv. Este posibil ca versiunile mai recente să functioneze în viitor, precum Xcode 14 (codul a fost testat si pe Xcode 14 Beta 1 & 2).

Aplicația este realizată în întregime in Swift. Aceasta foloseste SwiftUI și este compusă din mai multe View-uri (pentru senzori, relee, setări și automatizări), precum și modele (pentru date, grafice si automatizări). Totodată, am creat widget-uri (.systemMedium și .systemLarge) cu datele înregistrate de un anumit senzor în ziua respectivă dispuse sub formă de grafic, folosind WidgetKit și Intents.

Aplicația respectă regulile de thread concurrency ce vor fi aplicate începând cu Swift 6. Comunicarea cu API-ul se face prin functii asincronizate async / await, find astfel foarte responsive si neavând delay-uri.

# Legal
iPhone, iPad, Mac, Mac Catalyst si Xcode sunt mărci comerciale ale Apple Inc., înregistrate în S.U.A. și în alte țări și regiuni.
IOS este o marcă comercială sau o marcă comercială înregistrată a Cisco în S.U.A. și în alte țări.
