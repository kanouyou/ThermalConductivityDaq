#include "IDataCollection.h"

ClassImp(COMET::IDataCollection)

COMET::IDataCollection::IDataCollection()
    : fTime(0.), fVoltage(0.), fCurrent(0.)
{}

COMET::IDataCollection::IDataCollection(double time, double volt)
    : fTime(time), fVoltage(volt)
{}

COMET::IDataCollection::~IDataCollection()
{}

double COMET::IDataCollection::GetTime() const
{ return fTime; }

double COMET::IDataCollection::GetVoltage() const
{ return fVoltage; }

double COMET::IDataCollection::GetCurrent() const
{ return fCurrent; }
