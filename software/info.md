# Nanotool Raspberry Pi Software

This folder contains the weather station's source code, written for Raspberry Pi.
Moreover, this folder also contains a makefile that can be used to easily install this software on hardware, as well as the software's dependencies.

# Description
Nanotool runs a Python script after booting. This script monitors the weather using the sensors and runs the API web server (made with Flask).
The Python script contains threads for each sensor and activity (such as saving data at the specified time interval) 

# Install
The installer needs an active internet connection and root privileges.

## Method 1 - using raw.githubusercontent.com
Run the following command in the terminal to install:
```
curl https://raw.githubusercontent.com/iCMDgithub/nanotool/main/software/makefile > makefile; make
```
## Method 2 - using Release Installer

Download the [Makefile Installer](https://github.com/iCMDgithub/nanotool/releases) on the Raspberry Pi.
Then, use the ```make``` command in the folder where you downloaded the installer:
```
make
```
Note: In order for this to work properly, make sure you do not have any other makefiles in the current folder.

# Reboot Crontab
In order to run the code each time Nanotool is booted, use crontab. If it is the first time you use this command on your system, you will have to choose your preffered text editor.
```
crontab -e
```
At the end of the opened file, add the followin line to run the script at (re)boot:
```
@reboot python3 ~/webapi.py
```
# Run
To run the software, use the following command:
```
python3 ~/webapi.py
```

# API Security
It is recommended to create an user with limited privileges. This user should only have the privileges required to run the API.
The API, written in Flask, should run with production settings (not development).

# Legal
Raspberry Pi is a trademark of Raspberry Pi Ltd.
