# <img align="left" src="/repoAssets/nanotoolApp.png" width="100" alt="Nanotool logo"> Nanotool iOS & Mac Catalyst App
This directory contains the Nanotool App for iPhone, iPad and Mac, as an Xcode project. 

<img  src="/repoAssets/nanotoolAppPosterImage.png" alt="Nanotool App Banner">

<img align="left" src="/repoAssets/widgetTemp.png" width="300" alt="Nanotool logo"> The app is entirely made using Swift. It uses SwiftUI, and it's composed out of multiple Views (for sensors, relays, setiings and automations), as well as models (for data, charts and automations). Furthermore, widgets (.systemMedium and .systemLarge) are available. They display a sensor value's variation during the day as a chart. These widgets were created using WidgetKit and Intents.

The app respects the thread concurrency rules that will be applied starting with Swift 6. The communication with the API is made through asynchronous functions (with async / await), thus being very responsive and not having delays.

# Requirements
The app requires iOS 15.0 or a newer version on iPhone, respectively macOS 12 Monterey or a newer version on Mac. Furthermore, the latest Xcode 13 version is necessary to build & install the app on a device.

To install the app on a device, the code must be signed using Xcode / codesign (Xcode command line tool). Therefore, a development team must be selected in Signing & Capabilities editor. An Apple Developer Account (not necessarily with Apple Developer Program) is requred.

# Legal
iPhone, iPad, Mac, macOS, Mac Catalyst și Xcode are trademarks of Apple Inc., registered in the US and other countries and regions.
IOS is a trademark or a registered trademark of  Cisco in the US and other countries.
