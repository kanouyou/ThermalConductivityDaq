#ifndef IDataCollection_HH
#define IDataCollection_HH

namespace COMET
{ class IDataCollection; }

class COMET::IDataCollection {

  public:
    IDataCollection();
    IDataCollection(double time, double volt);
    ~IDataCollection();
    // set data
    void   SetCurrent(double curr) { fCurrent = curr; }
    void   SetVoltage(double volt) { fVoltage = volt; }
    void   SetTime   (double time) { fTime    = time; }

    // get data
    double GetCurrent() const;
    double GetVoltage() const;
    double GetTime   () const;

  private:
    double fTime;
    double fVoltage;
    double fCurrent;
};

#endif
