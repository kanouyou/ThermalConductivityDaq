# distutils: language = c++
# distutils: sources = IDataCollection.cpp

cdef extern from "IDataCollection.h" namespace "COMET":
	cdef cppclass IDataCollection:
		IDataCollection()
		void   SetTime   (double time)
		void   SetVoltage(double volt)
		void   SetCurrent(double curr)
		double GetTime   ()
		double GetVoltage()
		double GetCurrent()

cdef extern from "IDataSave.h" namespace "COMET":
	cdef cppclass IDataSave:
		IDataSave()

cdef class RunKeithley:
	cdef IDataCollection *data
	cdef IDataSave *tree

	def __cinit__(self):
		self.data = new IDataCollection()
		print self.data.GetVoltage()

	def __dealloc__(self):
		if self.data != NULL:
			del self.data

