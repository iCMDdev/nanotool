# <img align="left" src="/repoAssets/nanotool.png" width="100" alt="Nanotool logo"> Nanotool
A nano-sized weather station based on a Raspberry Pi with an API, iOS & Mac Catalyst app, and sensor-based automations.

# <img src="/repoAssets/nanotoolAll.png" alt="Nanotool App Banner">
# <img src="/repoAssets/nanotoolAppPosterImage.png" alt="Nanotool App Banner">
# <img src="/nanotoolCircuitDiagram.png" alt="Nanotool Circuit Diagram">

## Description
<img align="left" src="/repoAssets/nanotoolCentralUnitCloseUp.png" width="300" alt="Nanotool logo"> Weather is sometimes unpredictable. In addition, in many locations, there aren't weather stations nearby, so the forecast isn't actually accurate. Many of our actions depend on weather, from how we dress, to watering our flowers. What's sure is that we need to be informed about it. The Nanotool weather station solves these problems.<br/>

Nanotool is a weather station based on a Raspberry Pi 4B. It uses many sensors to monitor the atmospheric conditions, and has an API that makes communication straightforward. By using the iPhone, iPad and Mac app, controlling the weather station is as easy and simple as possible.<br/>

To understand it better in today's world, weather needs to be monitored. The station monitors weather daily (to be more precise, wind speed and direction, rainfall, temperature, air pressure and air humidity) and records the data. These data can be visualized as a chart, anytime, just by using the app.<br/>

Sometimes, an instant response to weather's actions is necessary. However, when people are not home, they cannot do things such as turning on a garden hose, or controlling some mechanically-driven curtains. Nanotool can automatically control many external devices by using the 4 relays and the API, which makes configuring these automations easier.<br/>

## Tehnologii
Nanotool uses a Raspberry Pi 4B (4GB RAM) with Raspberry Pi OS Lite (Bullseye, 64-bit). After booting, it runs a Python script that saves the data recorded by the sensors daily. This script also contains the web API, used by the app to communicate with the weather station.

###  Built-in API
<img align="left" src="/repoAssets/nanotoolAPI.png" width="50" alt="Nanotool logo"> Nanotool has a built-in API written using Flask (Python module).<br/>It facilitates communication with the station and creating acessories that use this API, such as the app itself. The API sends JSON responses to GET / POST requests, or CSV files when sensor data from previous days is downloaded.</br>
###### Find out more about software and API [here](/software/info.md).

###  iOS & Mac Catalyst App
<img align="left" src="/repoAssets/nanotoolApp.png" width="50" alt="Nanotool logo"> Nanotool has an application made using SwiftUI, a powerful user interface framework. It uses the API to get data from the weather station, and makes it even easier to control it.<br/>The app shows live data, as well as a data from the past. Both of them can be shown using charts.
###### Find out more about the app [here](/app/info.md).

### Automated Tasks
<img align="left" src="/repoAssets/nanotoolAuto.png" width="50" alt="Nanotool Automated Tasks logo"> Automated Tasks offer an instant response to weather. When a certain condition is met for a specified amount of time, one of the 4 relays can be toggled by Nanotool. Automations can be managed within the app, or by using the API separately. Nanotool facilitates automating tasks such as watering flowers, moving curtains, turning lights on or off, or turning a heating / cooling system on or off.

With the 4 relays, 2 types of accessories can be created:
   - <b>Simple acessories</b> - the relays act as a switch in a simple electric circuit
      <img src="/repoAssets/simpleAccessory.png"  alt="Simple accessory example">
   - <b>Inteligent acessories</b> - the relays act as a switch connected to a microcontroller (for example, a Raspberry Pi Pico, Arduino, ESP or an ATTINY85). In general, these accessories can automate more complex actions.
      <img src="/repoAssets/smartAccessory.png" alt="Smart accessory example"> 
   
Relays where chosen ofer transistors, since they offer more safety by separating the circuits.
Besides these relay-controlled accessories, others that use the API by themselves to check the data can be created.

###  Sensors
<img align="left" src="/repoAssets/nanotoolSensors.png" width="50" alt="Nanotool logo">The station includes many sensors that allows weather monitoring. Their data are registered daily in a CSV spreadsheet that can be accessed through the API as a JSON file, or simply downloaded.<br/></br>The used sensors are:
   - <b>Anemometer</b> - measures wind speed using a reed magnetic switch. At every rotation, a magnet travels above the switch, and toggles it, so that the rotation is registered by the Raspberry Pi.
   - <b>Wind direction sensor</b>
   - <b>Self-tipping Rain Gauge</b> - measures rainfall (liters / sq meter = mm) in a given time interval. This also uses a magnetic switch.
   - <b>BMP280</b> - measures temperature and barometric pressure
   - <b>DHT11</B> - measures air humidity
   - <b>Raspberry Pi Camera Module v2</b> - using OpenCV, the camera detects the presence of clouds, or absence of light (night)

The custom-made sensors (Anemometer, Wind Direction sensor and Rain Gauge), as well as the camera, need to be calibrated in order to give precise measurements.

### Internet, Connectivity & Settings
<img align="left" src="/repoAssets/nanotoolConnect.png" width="50" alt="Nanotool Connectivity logo"> The Nanotool weather station can be controlled by connecting it to the same internet network (through WiFi / Ethernet) as the controlling devices.</br> The API can be used to control the Python script's settings. Besides the API, there are other ways the OS settings can be modified:
   - using Raspberry Pi Imager, when installing the OS
   - controlling it directly, using a keyboard and a display (the board can be taken out of the central unit with ease)
   - through SSH

###  Product design & Sustainability - Recycled materials
The station is made using recycled materials, from sources such as lightbulbs, toys, food packaging, HDDs, electronic devices and electrical appliances. These could end up in a bin, but their fate was changed by Nanotool.

Nanotool's design is modern, simple, and modular, based on transparent elements that expose the custom-made sensors' mechanical components, and the electrical ones of the central unit. Even if itis made with recycled materials, Nanotools stands up to industrial standards, proving have increased rigidity and be resistant to environment factors, and also having an increased efficiency from a thermal point of view.

### LCD Display & CharPi library
All important sensor values are displayed on the 80-character, Hitachi HD44780 LCD with an I²C backpack. This display has an adaptive refresh rate - the display is refreshed only when data changes. To communicate with the display, Nanotool uses the [CharPi](https://www.github.com/iCMDgithub/CharPi) library, also made by the Nanotool's creator.

### I2C
Many of the components used by  Nanotool use I2C to communicate with the microcontroller:
   - <b>LCD 20x4 HD44780</b> - 80-character display
   - <b>BMP280</b> - temperature & pressure sensor
   - <b>ADS1115</b> - Analog-to-Digital Converter (ADC), used for the wind direction sensor

## Dependencies
### Software for Raspberry Pi
The software that runs on the Raspberry Pi was written in Python 3.</br>The following non-native Python modules were used for thesoftware:
   - <b>[CharPi](https://www.github.com/iCMDgithub/CharPi)</b> (library made by the Nanotool's creator) - used for communicating with the LCD through I2C
   - <b>Flask</b> - used for creating the web API server
   - <b>waitress</b> - used for the web server, when the API needs to run with production settings (not development)
   - <b>adafruit_dht</b> - used for the DHT11 sensor
   - <b>adafruit_ads1x15</b> - used for the ADC (ADS1115)
   - <b>adafruit_bmp280</b> - used for the BMP280 sensor
   - <b>board, busio</b> - dependencies for certain sensors that use the Adafruit CircuitPython libraries
   - <b>OpenCV</b> - used for analysing images taken by the camera
   - <b>picamera2</b> - used for communicating with the Raspberry Pi Camera Module v2
   - <b>RPi.GPIO</b> - used for controlling the GPIO pins
   - <b>gpiozero</b> - used for reading the CPU temperature (or the OS module could be used like this: os.popen("vcgencmd measure_temp").read())
   
### iOS & Mac Catalyst App
The app was entirely made using the Swift programming language.
The following <i>native</i> iOS SDK frameworks were used:
   - <b>SwiftUI</b> - used for the user interface
   - <b>WidgetKit</b> - used for creating Home Screen & Today View widgets for iOS devices
   - <b>Intents & IntentsUI</b> - used for managing the widgets' settings from the iOS Home Screen

## License
The assets (images) in this repo are not subject to the code open-source license.
Usage of these assets in any way, without the creator's consent is prohibited, unless the law permits it.

The license can be accessed [here](/LICENSE).

## Legal
iPhone, iPad, iPadOS, Mac and Mac Catalyst are trademarks of Apple Inc., registered in USA and other countries and regions.<br/> IOS is a trademark or a registered trademark of Cisco, in USA and other countries.<br/>Raspberry Pi is a trademark of Raspberry Pi Ltd.
