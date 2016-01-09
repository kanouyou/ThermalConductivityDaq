#ifndef IDataSave_HH
#define IDataSave_HH

#include <TFile.h>
#include <TTree.h>
#include <string>

namespace COMET
{ class IDataSave; }

class COMET::IDataSave {

  public:
    IDataSave();
    ~IDataSave();

  private:
    TFile* fFile;
    TTree* fTree;
};

#endif
