#include "IDataSave.h"

using std::string;

COMET::IDataSave::IDataSave()
    : fFile(new TFile("output.root", "recreate")),
      fTree(new TTree("tree", "Measurement Output"))
{}

COMET::IDataSave::~IDataSave()
{}


