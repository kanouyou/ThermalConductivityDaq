## @package LakeShore336 Control
#  Python Class to control the LakeShore 336 Temperature Controller
#
#  More details.

import math
import time
import visa

## LakeShore336 Temperature Controller Class.
#
#  More details.

class LakeShore336:
	
	## The constructor to active the GPIB address
	#  @param address<int> GPID address
	def __init__(self, address):
		rm = visa.ResourceManager()
		self.inst = rm.open_resource("GPIB0::%i::INSTR" %address)
	
	## Reset the controller parameters to power-up settings
	def Reset(self):
		self.inst.write("*CLS")
		self.inst.write("*RST")

	## Sensor input name command
	#  @param inputID<string> Input channel: A-D
	#  @param nameOfSensor<string> Name to associate with the sensor input channel
	def SetSensorName(self, inputID, nameOfSensor):
		self.inst.write("INNAME %s,\"%s\"" %(inputID, nameOfSensor))
	
	## Sensor input name query
	def GetSensorName(self):
		self.inst.write("INNAME?")
		nameOfSensor = self.inst.read()
		return nameOfSensor

	## Input type parameter command
	#  @param inputID<string> Input channel: A-D
	#  @param Type<int>   Input sensor type: 0=Disabled, 1=Diode, 2=Platinum RTD, 3=NTC RTD, 4=Thermocouple, 5=Capacitance
	#  @param aRange<int> Auto ranging: 0=OFF, 1=ON
	#  @param Range<int>  Input range when autorange is off (check the manual for detail)
	#  @param Comp<int>   Input compensation where 0=OFF and 1=ON
	#  @param Unit<int>   Units setup for sensor readings and control: 1=kevin, 2=Celsius, 3=Sensor
	def SetInputType(self, inputID, Type, aRange, Range, Comp, Unit):
		self.inst.write("INTYPE %s,%s,%s,%s,%s,%s" %(inputID, Type, aRange, Range, Comp, Unit))
		self.inst.write("INTYPE? %s" %inputID)
		print(" type setup: ", self.inst.read())

	def SetChannel(self, channel, curveID):
		self.inst.write("INCRV %s,%i" %(channel, curveID))
		self.inst.write("INCRV? %s" %channel)

	## Autotune command
	#  @param output<int> The output associated with the loop to be autotuned: 1-4
	#  @param mode<int>   Autotune mode: 0=P only, 1=P and I, 2=P, I and D
	def SetAutoTune(self, output, mode):
		self.inst.write("ATUNE %i,%i" %(output, mode))
	
	## Delete the curve
	#  @param curveID<int> User curve to detele. valid enetries: 21-59
	def ClearCurve(self, curveID):
		self.inst.write("CRVDEL %i" %curveID)
	
	## Set curve header
	def SetCurveHeader(self, curveNum, curveName, serialNum, dataFormat, maxTemp, factor):
		self.inst.write("CRVHDR %i,%s,%s,%i,%.1f,%i" %(curveNum, curveName, serialNum, dataFormat, maxTemp, factor))
		self.inst.write("CRVHDR? %i" %curveNum)
		print(" curve header: ", self.inst.read())
	
	## Set curve from calibration data
	def SetCalibData(self, dataFile, curveNum):
		# read each line for data file:
		fFile    = open(dataFile, "r")
		dataLine = fFile.readlines()
		fFile.close()
		dataline = []
		del dataLine[0:3]
		n = len(dataLine)
		for i in range(n):
			dataline.append(dataLine[n-(i+1)])
		# sort of data
		counter2 = 0
		for eachLine in dataline:
			eachLine.strip()
			item = eachLine.split()
			temp = float(item[0])
			rest = math.log10(float(item[1]))
			counter2  = counter2 + 1
			self.inst.write("CRVPT %i,%i,%f,%f" %(curveNum, counter2, rest, temp))
	
	## Get the data from curve
	def GetCalibData(self, curveID, index):
		self.inst.write("CRVPT? %i,%i" %(curveID, index))
		data = self.inst.read()
		data.strip()
		item = data.split(",")
		return float(item[0]), float(item[1])

	## Heater output in unit of percent
	def GetHeaterOutput(self, heaterNum):
		self.inst.write("HTR? %i" %heaterNum)
		outHeat = self.inst.read()
		return outHeat
	
	## Setup heater
	#  @param heaterID<int> Heater channel
	def SetHeater(self, heaterID, res, maxCurrent, maxUserCurrent, option):
		self.inst.write("HTRSET %i,%i,%i,%f,%i" %(heaterID, res, maxCurrent, maxUserCurrent, option))

	## Return the setup of heater
	#  @param heaterID<int> Heater channel
	def GetHeatSetup(self, heaterID):
		self.inst.write("HTRSET? %i" %heaterID)
		print(" heater setup: ", self.inst.read())
	
	## Set heater range
	#  @param heaterID<int> Heater channel
	#  @param heaterRange<int> Heater range: for 1 and 2: 0=OFF, 1=LOW, 2=MEDIUM, 3=HIGH; for 3 and 4: 0=OFF, 1=ON
	def SetHeaterRange(self, heaterID, heaterRange):
		self.inst.write("RANGE %i,%i" %(heaterID, heaterRange))
	
	## Print the heater range setup
	#  @param heaterID<int> Heater channel
	def GetHeaterRange(self, heaterID):
		if heaterID==1 or heaterID==2:
			self.inst.write("RANGE? %i" %heaterID)
			rangeID = self.inst.read()
			if rangeID==0:
				print(" heater range: OFF")
			elif rangeID==1:
				print(" heater range: LOW")
			elif rangeID==2:
				print(" heater range: MEDIUM")
			else:
				print(" heater range: HIGH")
	
	## Set the curve ID to the input ID
	#  @param inputID<int>  Input channel: A-D
	#  @param curveNum<int> Data curve ID
	def SetCurveToInput(self, inputID, curveNum):
		self.inst.write("INCRV %s,%i" %(inputID, curveNum))
	
	## Print the curve setup for input
	#  @param inputID<int> Input channel: A-D
	def CheckCurveSetup(self, inputID):
		self.inst.write("INCRV? %s" %inputID)
		print(" curve ", self.inst.read(), " is setup to input %s" %inputID)
	
	## Get the temperature in unit [K]
	#  @param channel<int> Input channel: 1-16
	def GetTemperature(self, ltime, channel):
		numOfReadings = 10
		dt = ltime / numOfReadings
		data = []
		for i in range(numOfReadings):
			self.inst.write("KRDG? %s" %channel)
			data.append(float(self.inst.read()))
			time.sleep(dt)
		sumOfTemp = sum(data)
		maxOfTemp = max(data)
		minOfTemp = min(data)
		average = sumOfTemp / numOfReadings
		sigma2  = maxOfTemp - average
		sigma1  = average - minOfTemp
		return average, sigma1, sigma2
	
	## Set the command directly to control the temperature controller
	#  @param command<string> Lakeshore operation command. 
	def SetUserCommand(self, command):
		self.inst.write(command)
		value = self.inst.read()
		return value



