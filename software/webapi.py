from flask import *
import json
import threading
import time
import CharPi
import socket
import time
import RPi.GPIO as GPIO
from gpiozero import CPUTemperature

# Pins
windPin = 25
relay1Pin = 24
relay2Pin = 23
relay3Pin = 22
relay4Pin = 27
rainPin = 8

version = 1.0
status = 200
temperature = 0
humidity = 0
pressure = 0

dataInterval = 15
captureInterval = 5

cpu = CPUTemperature()
startTime = time.strftime("%Y-%m-%d %H:%M:%S")

class LCDrefresh:
    updateLCD = False
    
lcdRefresh = LCDrefresh()

class Camera:
    skyDetails = "Clear sky"
    
    r1 = 78
    g1 = 235
    b1 = 252
    
    r2 = 13
    b2 = 181
    g2 = 181
    
camera = Camera()
    
class AutomatedTask:
    ID = 0
    sensor = 1
    comparison = 1
    turnOn = 1
    minutes = 1
    value = 1
    relayID = 1
    stateBeginTime = time.time()
    currentState = 0
    
    def __init__(self, ID, sensor, comparison, turnOn, minutes, value, relayID):
        self.ID = int(ID)
        self.sensor = int(sensor)
        self.comparison = int(comparison)
        self.turnOn = int(turnOn)
        self.minutes = int(minutes)
        self.value = int(value)
        self.relayID = int(relayID)
    
automatedTasks = []

def taskThread():
    global temperature
    global humidity
    global pressure
    global automatedTasks
    global rainGauge	
	
    while True:
        for task in automatedTasks:
            if task.sensor == 1:
                if task.comparison == 1:
                    if temperature < task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature < task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (temperature < task.value):
                        task.currentState = 0
                elif task.comparison == 2:
                    if temperature <= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature <= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (temperature <= task.value):
                        task.currentState = 0
                elif task.comparison == 3:
                    if temperature == task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature == task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (temperature == task.value):
                        task.currentState = 0
                elif task.comparison == 4:
                    if temperature != task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature != task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (temperature != task.value):
                        task.currentState = 0
                elif task.comparison == 5:
                    if temperature > task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature > task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (temperature > task.value):
                        task.currentState = 0
                elif task.comparison == 6:
                    if temperature >= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif temperature >= task.value and task.currentState == 0:
                        task.stateBeginTime =time.time()
                        task.currentState = 1
                    elif not (temperature >= task.value):
                        task.currentState = 0
            elif task.sensor == 2:
                if task.comparison == 1:
                    if humidity < task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity < task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity < task.value):
                        task.currentState = 0
                elif task.comparison == 2:
                    if humidity <= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity <= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity <= task.value):
                        task.currentState = 0
                elif task.comparison == 3:
                    if humidity == task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity == task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity == task.value):
                        task.currentState = 0
                elif task.comparison == 4:
                    if humidity != task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity != task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity != task.value):
                        task.currentState = 0
                elif task.comparison == 5:
                    if humidity > task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity > task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity > task.value):
                        task.currentState = 0
                elif task.comparison == 6: 
                    if humidity >= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif humidity >= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity >= task.value):
                        task.currentState = 0
            elif task.sensor == 3:
                if task.comparison == 1:
                    if wind.speed < task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed < task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity < task.value):
                        task.currentState = 0
                elif task.comparison == 2:
                    if wind.speed <= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed <= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (humidity <= task.value):
                        task.currentState = 0
                elif task.comparison == 3:
                    if wind.speed == task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed == task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (wind.speed == task.value):
                        task.currentState = 0
                elif task.comparison == 4:
                    if wind.speed != task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed != task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (wind.speed != task.value):
                        task.currentState = 0
                elif task.comparison == 5:
                    if wind.speed > task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed > task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (wind.speed > task.value):
                        task.currentState = 0
                elif task.comparison == 6: 
                    if wind.speed >= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif wind.speed >= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (wind.speed >= task.value):
                        task.currentState = 0
            elif task.sensor == 4:
                if task.comparison == 3:
                    if task.value == 1:
                        if camera.skyDetails == "Clear" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails == "Clear" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails == "Clear"):
                            task.currentState = 0
                    elif task.value == 2:
                        if camera.skyDetails == "Cloudy" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails == "Cloudy" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails == "Cloudy"):
                            task.currentState = 0
                    elif task.value == 3:
                        if camera.skyDetails == "Night" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails == "Night" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails == "Night"):
                            task.currentState = 0
                elif task.comparison == 4:
                    if task.value == 1:
                        if camera.skyDetails != "Clear" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails != "Clear" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails != "Clear"):
                            task.currentState = 0
                    elif task.value == 2:
                        if camera.skyDetails != "Cloudy" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails != "Cloudy" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails != "Cloudy"):
                            task.currentState = 0
                    elif task.value == 3:
                        if camera.skyDetails != "Night" and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                            relays.setRelay(task.relayID, (task.turnOn==1))
                        elif camera.skyDetails != "Night" and task.currentState == 0:
                            task.stateBeginTime = time.time()
                            task.currentState = 1
                        elif not (camera.skyDetails != "Night"):
                            task.currentState = 0
            elif task.sensor == 5:
                if task.comparison == 1:
                    if pressure < task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure < task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure < task.value):
                        task.currentState = 0
                elif task.comparison == 2:
                    if pressure <= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure <= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure <= task.value):
                        task.currentState = 0
                elif task.comparison == 3:
                    if pressure == task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure == task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure == task.value):
                        task.currentState = 0
                elif task.comparison == 4:
                    if pressure != task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure != task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure != task.value):
                        task.currentState = 0
                elif task.comparison == 5:
                    if pressure > task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure > task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure > task.value):
                        task.currentState = 0
                elif task.comparison == 6:
                    if pressure >= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif pressure >= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (pressure >= task.value):
                        task.currentState = 0
            elif task.sensor == 6:
                if task.comparison == 1:
                    if rainGauge.value < task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value < task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value < task.value):
                        task.currentState = 0
                elif task.comparison == 2:
                    if rainGauge.value <= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value <= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value <= task.value):
                        task.currentState = 0
                elif task.comparison == 3:
                    if rainGauge.value == task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value == task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value == task.value):
                        task.currentState = 0
                elif task.comparison == 4:
                    if rainGauge.value != task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value != task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value != task.value):
                        task.currentState = 0
                elif task.comparison == 5:
                    if rainGauge.value > task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value > task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value > task.value):
                        task.currentState = 0
                elif task.comparison == 6:
                    if rainGauge.value >= task.value and task.currentState == 1 and (time.time()-task.stateBeginTime)/60 >= task.minutes:
                        relays.setRelay(task.relayID, (task.turnOn==1))
                    elif rainGauge.value >= task.value and task.currentState == 0:
                        task.stateBeginTime = time.time()
                        task.currentState = 1
                    elif not (rainGauge.value >= task.value):
                        task.currentState = 0
        time.sleep(1)
            
                        

class Wind:
    lastRotation = 0
    currentRotation = 0
    state = False
    speed=22
    RPM = 100
    radius = 0.125
    speedSum = 0
    speedCount = 0
    maxSpeed = 0
    minSpeed = 99
    direction = ""

wind = Wind()

def windDirection():
    # aceasta functie afla directia vantului de la girueta
        
    # Equivalent resistor values for each position
    Nminvalue = 123
    Nmaxvalue = 456
    NEminvalue = 789
    NEmaxvalue = 1011
    Eminvalue = 1213
    Emaxvalue = 1314
    SEminvalue = 1415
    SEmaxvalue = 1516
    Sminvalue = 1617
    Smaxvalue = 1718
    SWminvalue = 1819
    SWmaxvalue = 2020
    Wminvalue = 2121
    Wmaxvalue = 2222
    NWminvalue = 2323
    NWmaxvalue = 2424
    try:
        import board
        import busio
        import adafruit_ads1x15.ads1015 as ADS
        from adafruit_ads1x15.analog_in import AnalogIn

        i2c = busio.I2C(board.SCL, board.SDA)
        ads = ADS.ADS1015(i2c, address=0x48)
        chan = AnalogIn(ads, ADS.P0)

        if chan.value >= Nminvalue and chan.value <= Nmaxvalue:
            return 1 # N
        if chan.value >= NEminvalue and chan.value <= NEmaxvalue:
            return 2 # NE
        if chan.value >= Eminvalue and chan.value <= Emaxvalue:
            return 3 # E
        if chan.value >= SEminvalue and chan.value <= SEmaxvalue:
            return 4 # SE
        if chan.value >= Sminvalue and chan.value <= Smaxvalue:
            return 5 # S
        if chan.value >= SWminvalue and chan.value <= SWmaxvalue:
            return 6 # SW
        if chan.value >= Wminvalue and chan.value <= Wmaxvalue:
            return 7 # W
        if chan.value >= NWminvalue and chan.value <= NWmaxvalue:
            return 8 # NW
    except Exception:
        pass
    return 0 # unknown, please calibrate / check wiring!


def windRead():
    global wind
    global windPin
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(windPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    wind.lastRotation = time.time()-20
    try:  
        while True:
            state1 = GPIO.input(windPin)
            if state1==True and wind.state == False:
                
                wind.state = True
                wind.currentRotation = time.time()
                
                wspeed = round(2*3.1415/(wind.currentRotation-wind.lastRotation)*wind.radius*3.6, 2)
                if (wspeed - wind.speed >= 1) or (wspeed - wind.speed <= -1):
                    wind.speed = wspeed
                    # Update wind direction
                    windDirValue = windDirection()
                    if windDirValue == 1:
                        wind.direction = "N"
                    elif windDirValue == 2:
                        wind.direction = "NE"
                    elif windDirValue == 3:
                        wind.direction = "E"
                    elif windDirValue == 4:
                        wind.direction = "SE"
                    elif windDirValue == 5:
                        wind.direction = "S"
                    elif windDirValue == 6:
                        wind.direction = "SW"
                    elif windDirValue == 7:
                        wind.direction = "W"
                    elif windDirValue == 8:
                        wind.direction = "NW"
                    else:
                        wind.direction = "-"
                    lcdRefresh.updateLCD = True
                wind.speedSum =  wind.speedSum + wspeed
                wind.speedCount = wind.speedCount + 1
                if wspeed > wind.maxSpeed and wind.speedCount != 1:
                    wind.maxSpeed = wspeed
                if wspeed < wind.minSpeed and wind.speedCount != 1:
                    wind.minSpeed = wspeed
                wind.lastRotation = wind.currentRotation
            elif state1==False and wind.state == True:
                wind.state = False
            elif ((state1==False and wind.state == False) or (state1==True and wind.state == True)) and time.time() - wind.lastRotation > 15:
                if wind.speed != 0:
                    wind.speed = 0
                    lcdRefresh.updateLCD = True
            time.sleep(0.001)  
    except KeyboardInterrupt:
        pass
        
class RainGauge:
    state = False
    value = 0
    valuePerTick = 0.000105229512143
    startTime = time.time()
    didSave = False

rainGauge = RainGauge()

def rainGaugeRead():
    global rainPin
    global rainGauge
    global dataInterval
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(rainPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    try:
        while True:
            state1 = GPIO.input(rainPin)
            if time.time()-rainGauge.startTime > dataInterval*60 and rainGauge.didSave == True:
                rainGauge.startTime = time.time()
                rainGauge.value=0
                rainGauge.didSave = False
            if state1 == True and rainGauge.state == False:
                rainGauge.state = True
                rainGauge.value = rainGauge.value + rainGauge.valuePerTick
                lcdRefresh.updateLCD = True
            elif state1==False and rainGauge.state == True:
                rainGauge.state = False
            time.sleep(0.001)
    except KeyboardInterrupt:
        pass
def cameraUpdate():
    import cv2
    import numpy as np
    from picamera2 import Picamera2 # new picamera for Raspbian OS Bullseye, tested alpha release
    import time

    picam2 = Picamera2()
    picam2.configure(picam2.create_preview_configuration(main={"format": 'XRGB8888', "size": (640, 480)}))
    picam2.start()
    time.sleep(0.1)
    
    while True:
        frame = picam2.capture_array()

        # DAYTIME CLOUD DETECTION / NIGHT SKY DETECTION
        # Values can be adjusted for calibration
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        upBlue = np.array([135, 255, 255])
        lowBlue = np.array([90, 50, 120])
        upNight = np.array([180, 255, 50])
        lowNight = np.array([0, 0, 0])
        
        

        cloudMask = cv2.inRange(rgb, lowBlue, upBlue)
        nightMask = cv2.inRange(rgb, lowNight, upNight)

        skyClouds = cv2.bitwise_and(frame,frame, mask=cloudMask)

        # mask white pixels (sky blue)
        skyBluePixels = np.count_nonzero(cloudMask)
        nightPixels = np.count_nonzero(nightMask)
        if skyBluePixels/307200.0*100 >=60:
            camera.skyDetails="Clear"
            lcdRefresh.updateLCD=True
        elif skyBluePixels/307200.0*100 >=30:
            camera.skyDetails="Cloudy"
            lcdRefresh.updateLCD=True
        elif nightPixels/307200.0*100 >=60:
            camera.skyDetails="Night"
            lcdRefresh.updateLCD=True
        else:
            camera.skyDetails="Very cloudy"
            lcdRefresh.updateLCD=True

        pixels = frame.reshape((-1,3))
        pixels = np.float32(pixels)
        # K-means clustering - detecting the 2 dominant colors
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 0.75)
        clusters = 2
        _, _, colors = cv2.kmeans(pixels, clusters, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS)
        colors = np.uint8(colors) # values are float, convert to 1 byte int (rgb max 255)
        camera.r1=colors[0][0]
        camera.g1=colors[0][1]
        camera.b1=colors[0][2]
        camera.r2=colors[1][0]
        camera.g2=colors[1][1]
        camera.b2=colors[1][2]
        time.sleep(captureInterval)
        
    cap.release()



def numOfDigits(x):
    i = 0
    while x>0:
        x=x//10
        i = i+1
    return i

def LCDupdate():
    # actualizeaza informatiile de pe LCD
    LCD = CharPi.HD44780I2Cdriver(lines=4, columns=20)
    time.sleep(1)
    LCD.clear()
    time.sleep(1)
    while True:
        host = socket.gethostname() # pentru afisarea IP-ului
        if lcdRefresh.updateLCD == True or IP != socket.gethostbyname(host + ".local"):
            # daca un thread a schimbat vreo variabila globala
            # atunci va seta lcdRefresh.updateLCD la True
            IP = socket.gethostbyname(host + ".local") # IP-ul nou
            LCD.writeString(f'nanotool|{camera.skyDetails}{" "*(11-len(camera.skyDetails))}\n{temperature}C {humidity}% {round(pressure, 1)}hPa{" "*(13-len(str(temperature))-len(str(humidity)) - len(str(round(pressure, 1))))}\n{round(wind.speed, 1)}km/h {wind.direction} {round(rainGauge.value, 3)}mm{" "*(10-len(str(wind.direction))-len(str(round(wind.speed, 1)))-len(str(round(rainGauge.value, 3))))}\n{IP}:5000 ', lineNum=0, columnNum=0, delay=0, newlineDelay=0, disableAutoNewline=True)
            lcdRefresh.updateLCD = False
        time.sleep(0.1)

def DHT11loadData():
    import time
    import board
    import adafruit_dht
    
    dhtDevice = adafruit_dht.DHT11(board.D4, use_pulseio=False)
    global temperature
    global humidity
    while True:
        try:
            temperature1 = dhtDevice.temperature
            humidity1 = dhtDevice.humidity
            #if temperature1 != temperature:
            #    lcdRefresh.updateLCD = True
            #    temperature = temperature1
            if humidity1 != humidity and humidity1 != None:
                lcdRefresh.updateLCD = True
                humidity = humidity1
     
        except RuntimeError as error:
            # couldn't read value from DHT11 - pass
            time.sleep(0.1)
            continue
        except Exception as error:
            # other error - raise
            dhtDevice.exit()
            raise error
        time.sleep(captureInterval)

def BMP280loadData():
    import board
    import adafruit_bmp280
    import time

    global pressure
    global temperature
    i2c = board.I2C()
    sensor = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address = 0x76)

    while True:
        try:
            pressure = sensor.pressure
            temperature1 = sensor.temperature
            if round(temperature1, 1) != temperature:
                lcdRefresh.updateLCD = True
                temperature = round(temperature1, 1)
        except Exception as error:
            print(error)
        time.sleep(captureInterval)


def resetWind():
	global wind
	wind.minSpeed = 99
	wind.maxSpeed = 0
	wind.speedCount = 0
	wind.speedSum = 0

def storeData():
    global temperature
    global humidity
    global wind
    global pressure
    global rainGauge
    while True:
        resetWind()
        i = 0
        while i < dataInterval*60:
            time.sleep(1)
            i = i + 1
        print("SAVING DATA...")
        with open("/home/pi/"+time.strftime("%Y-%m-%d")+".csv", "a") as csvLog:
            wspeed = 0.0
            wspeedmin = wind.minSpeed
            if wind.speedCount != 0:
                wspeed = wind.speedSum/wind.speedCount
            if wind.minSpeed == 99:
                wspeedmin = 0
            csvLog.write("{0},{1},{2},{3},{4},{5},{6},{7}\n".format(time.strftime("%Y-%m-%d %H:%M:%S"), str(temperature), str(humidity), str(wspeed), str(wind.maxSpeed), str(wspeedmin), str(pressure), str(rainGauge.value)))
        print("Done saving data.")
        rainGauge.didSave = True

class Relays:
  relayA = 0
  relayB = 0
  relayC = 0
  relayD = 0
  
  def __init__(self):
    # opreste releele la initializare
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(relay1Pin, GPIO.OUT)
    GPIO.output(relay1Pin, True)
    GPIO.setup(relay2Pin, GPIO.OUT)
    GPIO.output(relay2Pin, True)
    GPIO.setup(relay3Pin, GPIO.OUT)
    GPIO.output(relay3Pin, True)
    GPIO.setup(relay4Pin, GPIO.OUT)
    GPIO.output(relay4Pin, True)
  
  def setRelay(self, relayID, value):
    valueInt = 0
    if value == True:
        valueInt = 1
        
    if relayID == 1:
        relayID = relay1Pin
        self.relayA = valueInt
    elif relayID == 2:
        relayID = relay2Pin
        self.relayB = valueInt
    elif relayID == 3:
        relayID = relay3Pin
        self.relayC = valueInt
    elif relayID == 4:
        relayID = relay4Pin
        self.relayD = valueInt
        
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(relayID, GPIO.OUT)
    GPIO.output(relayID, (value == False))

relays = Relays()

app = Flask(__name__)

@app.route('/',methods=['GET', 'POST'])
def testAPI():
    return f'{{"name": "nanotool API", "version": {version}, "isRunning": {status}}}'

@app.route('/relays', methods=['GET', 'POST'])
def relaysAPI():
  if request.method == 'GET':
    return f'{{"relay1": {relays.relayA}, "relay2": {relays.relayB}, "relay3": {relays.relayC},  "relay4": {relays.relayD}}}'
  elif request.method == 'POST':
    if 'relay1' in request.form:
      if request.form['relay1'] == "0" or request.form['relay1'] == "1":
        relays.setRelay(1, int(request.form['relay1'])==1)
      else:
        return f'{{"status": 400}}', 400 # bad request
    if 'relay2' in request.form:
      if request.form['relay2'] == "0" or request.form['relay2'] == "1":
        relays.setRelay(2, int(request.form['relay2'])==1)
      else:
        return f'{{"status": 400}}', 400 # bad request
    if 'relay3' in request.form:
      if request.form['relay3'] == "0" or request.form['relay3'] == "1":
        relays.setRelay(3, int(request.form['relay3'])==1)
      else:
        return f'{{"status": 400}}', 400 # bad request
    if 'relay4' in request.form:
      if request.form['relay4'] == "0" or request.form['relay4'] == "1":
        relays.setRelay(4, int(request.form['relay4'])==1)
      else:
        return f'{{"status": 400}}', 400 # bad request
    return f'{{"status": 200}}'

@app.route('/tasks',methods=['GET'])
def getTasksAPI():
    string = f'['
    for i in range(0, len(automatedTasks)):
        string+=f'{{"id": {i}, "sensor": {automatedTasks[i].sensor}, "comparison": {automatedTasks[i].comparison}, "turnOn": {automatedTasks[i].turnOn}, "minutes": {automatedTasks[i].minutes}, "value": {automatedTasks[i].value}, "relayID": {automatedTasks[i].relayID}}}'
        if i < len(automatedTasks)-1:
            string+=f', '
    string += f']'
    return string

@app.route('/remove-tasks',methods=['GET'])
def removeTasksAPI():
  for i in range(0, len(automatedTasks)):
      automatedTasks.pop(0)
  return f'{{"status": 200}}'

@app.route('/set-task',methods=['POST'])
def setTaskAPI():
    task = AutomatedTask(request.form['id'], request.form['sensor'], request.form['comparison'], request.form['turnOn'], request.form['minutes'], request.form['value'], request.form['relayID']) 
    automatedTasks.append(task)
    return f'{{"status": 200}}'

@app.route('/sensors',methods=['GET'])
def sensorsAPI():
    return f'{{"temperature": {tempAPI()}, "humidity": {humidAPI()}, "wind": {windAPI()}, "camera": {cameraAPI()}, "pressure": {pressureAPI()}, "rain": {rainAPI()}}}'

@app.route('/sensors/humidity',methods=['GET'])
def humidAPI():
    global humidity
    return f'{{"sensorName": "humidity", "value": {humidity}}}'

@app.route('/sensors/temperature',methods=['GET'])
def tempAPI():
    return f'{{"sensorName": "temperature", "value": {temperature}, "unit": "C"}}'
    
@app.route('/sensors/pressure',methods=['GET'])
def pressureAPI():
    return f'{{"sensorName": "pressure", "value": {pressure}, "unit": "hPa"}}'
    
@app.route('/sensors/rain',methods=['GET'])
def rainAPI():
    return f'{{"sensorName": "rain", "value": {rainGauge.value}, "unit": "mm"}}'

@app.route('/sensors/wind',methods=['GET'])
def windAPI():
    return f'{{"sensorName": "wind", "value": {wind.speed}, "unit": "RPM", "direction": "{wind.direction}"}}'
    
@app.route('/captureInterval',methods=['GET', 'POST'])
def captureIntervalAPI():
    global captureInterval
    if request.method == 'GET':
        return f'{{"captureInterval": {captureInterval}}}'
    else:
        if 'captureInterval' in request.form:
                captureInterval = int(request.form['captureInterval'])
        return f'{{"status": 200}}'
    
@app.route('/saveInterval',methods=['GET', 'POST'])
def saveIntervalAPI():
    global dataInterval
    if request.method == 'GET':
        return f'{{"saveInterval": {int(dataInterval)}}}'
    else:
        if 'saveInterval' in request.form:
                dataInterval = int(request.form['saveInterval'])
        return f'{{"status": 200}}'

@app.route('/sensors/camera',methods=['GET'])
def cameraAPI():
    return f'{{"sensorName": "camera", "value": "{camera.skyDetails}", "unit": null, "r1": {camera.r1} , "g1": {camera.g1}, "b1": {camera.b1}, "r2": {camera.r2}, "g2": {camera.g2}, "b2": {camera.b2}}}'

@app.route('/chart',methods=['POST'])
def chartDataAPI():
    try:
        if 'sensor' in request.form and 'date' in request.form:
            if request.form['sensor'] == "temperature":
                str = f'['
                with open("/home/pi/" + request.form['date'] + ".csv", "r") as csvLogRead:
                    lines = csvLogRead.readlines()
                    for i in range(0, len(lines)):
                        #print(lines[i].split(","))
                        str = str + f'{{"value": {lines[i].split(",")[1]}, "time": "{lines[i].split(",")[0]}"}}'
                        if i != len(lines) - 1:
                            str = str + ","
                str = str + "]"
                return str
            elif request.form['sensor'] == "humidity":
                str = f'['
                with open("/home/pi/" + request.form['date'] + ".csv", "r") as csvLogRead:
                    lines = csvLogRead.readlines()
                    for i in range(0, len(lines)):
                        #print(lines[i].split(","))
                        str = str + f'{{"value": {lines[i].split(",")[2]}, "time": "{lines[i].split(",")[0]}"}}'
                        if i != len(lines) - 1:
                            str = str + ","
                str = str + "]"
                return str
            elif request.form['sensor'] == "wind":
                str = f'['
                with open("/home/pi/" + request.form['date'] + ".csv", "r") as csvLogRead:
                    lines = csvLogRead.readlines()
                    for i in range(0, len(lines)):
                        #print(lines[i].split(","))
                        str = str + f'{{"value": {lines[i].split(",")[3]}, "valueMax": {lines[i].split(",")[4]}, "valueMin": {lines[i].split(",")[5]},  "time": "{lines[i].split(",")[0]}"}}'
                        if i != len(lines) - 1:
                            str = str + ","
                str = str + "]"
                return str
            elif request.form['sensor'] == "pressure":
                str = f'['
                with open("/home/pi/" + request.form['date'] + ".csv", "r") as csvLogRead:
                    lines = csvLogRead.readlines()
                    for i in range(0, len(lines)):
                        #print(lines[i].split(","))
                        str = str + f'{{"value": {lines[i].split(",")[6]}, "time": "{lines[i].split(",")[0]}"}}'
                        if i != len(lines) - 1:
                            str = str + ","
                str = str + "]"
                return str
            elif request.form['sensor'] == "rain":
                str = f'['
                with open("/home/pi/" + request.form['date'] + ".csv", "r") as csvLogRead:
                    lines = csvLogRead.readlines()
                    for i in range(0, len(lines)):
                        str = str + f'{{"value": {lines[i].split(",")[7]}, "time": "{lines[i].split(",")[0]}"}}'
                        if i != len(lines) - 1:
                            str = str + ","
                str = str + "]"
                return str
        else:
            return f'{{"status": 400}}', 400
    except Exception:
            return f'{{"status": 404}}', 404

@app.route('/csv')
def usageCSV():
    return "Usage: /csv/date (yyyy-mm-dd)"

@app.route('/csv/<csvDate>')
def downloadCSV(csvDate):
        try:
                return send_file('/home/pi/' + str(csvDate) + '.csv', as_attachment=True)
        except Exception as e:
                return "No data found.", 404

if __name__ == "__main__":
    threading.Thread(target=lambda: app.run(host ='0.0.0.0', port=5000, threaded=True, use_reloader=False)).start()

@app.route('/info', methods=['GET'])
def info():
    global cpu
    global captureInterval
    global dataInterval
    return f'{{"uptime": "{startTime}", "temperature": {cpu.temperature}, "captureInterval": {captureInterval}, "saveInterval": {dataInterval}}}'

threading.Thread(target=LCDupdate).start()
threading.Thread(target=DHT11loadData).start()
threading.Thread(target=windRead).start()
threading.Thread(target=rainGaugeRead).start()
threading.Thread(target=cameraUpdate).start()
threading.Thread(target=storeData).start()
threading.Thread(target=BMP280loadData).start()
taskThread()

