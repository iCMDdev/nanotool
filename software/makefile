all: initial flask adafruit-dht adafruit-blinka adafruit-circuitpython-dht opencv-python picamera2 charpi bmp280 nanotoolAPI flaskEnvironment autoremove

initial:
	sudo apt-get update
	sudo apt-get install python3-pip
	sudo apt-get install i2c-tools
	sudo apt-get install git
	pip3 install smbus

adafruit-dht:
	sudo pip3 install $@ --install-option="--force-pi"

flask adafruit-blinka adafruit-circuitpython-dht opencv-python:
	sudo pip3 install $@

bmp280:
	sudo pip3 install adafruit-circuitpython-bmp280

picamera2:
	sudo apt install -y python3-libcamera python3-kms++
	sudo apt install -y python3-pyqt5 python3-prctl libatlas-base-dev ffmpeg python3-pip
	pip3 install numpy --upgrade
	pip3 install picamera2

charpi:
	git clone https://github.com/iCMDgithub/CharPi.git
	cd CharPi/code; sudo python3 setup.py install

flaskEnvironment:
	export FLASK_ENV=development

nanotoolAPI:
	git clone https://github.com/iCMDgithub/nanotool.git
	cd nanotool/software; mv webapi.py ~/webapi.py

autoremove:
	echo -e "\n\n\n\n\nFinished installing. Auto removing unnecessary files.\n\n\n\n\n"
	sudo rm -rf CharPi
	sudo rm -rf nanotool
	sudo apt autoremove
	echo -e "\n\n\n\n\nFinished. You can run the software using python3 ~/webapi.py.\nConsider adding the foregoing command to crontab to run it every time Nanotool is booted, using the instructions in the repo, at /software/info.md"
