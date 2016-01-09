## @package Keithley 2010 Control Program
#  Python class for controlling Keithley 2010

import visa
import time

class Keithley2010:
	## The constructor for opening one GPIB address
	def __init__(self, address):
		rm = visa.ResourceManager()
		self.inst = rm.open_resource("GPIB0::%i::INSTR" %address)
		self.inst.write("*IDN?")
		print("Machine Type: %s" %self.inst.read())

	def DataTaking(self, delay):
		numOfReadings = 5
		self.inst.write("trigger:delay %f" %(delay/numOfReadings))
		self.inst.write("trace:points %d" %numOfReadings)
		self.inst.write("trace:feed sense1; feed:control next")
		time.sleep(delay)
		self.inst.write("trace:data?")
		data = self.inst.read()
		item = data.split(",")
		readings = []
		for i in range(len(item)):
			readings.append(float(item[i]))
		readings.remove(min(readings))
		readings.remove(max(readings))
		#print(readings)
		sumOfReadings = sum(readings)
		maxOfReadings = max(readings)
		self.average  = sumOfReadings / (numOfReadings-2)
		self.maxSigma = maxOfReadings - self.average
		self.minSigma = self.average - min(readings)
	
	def SetScanner(self, currentChannel):
		#self.inst.write("trigger:delay 1")
		self.inst.write("route:scan:internal (@%i)" %currentChannel)
		#self.inst.write("route:scan:internal?")
		#print(self.inst.read())

	def GetValue(self):
		return self.average

	def GetMinSigma(self):
		return self.minSigma

	def GetMaxSigma(self):
		return self.maxSigma
