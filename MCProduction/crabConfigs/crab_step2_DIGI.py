from CRABClient.UserUtilities import config
config = config()
config.General.transferOutputs = True
config.General.requestName = 'DIGI_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'

config.JobType.psetName = 'step2_DIGI.py'
config.JobType.pluginName = 'Analysis'
config.JobType.maxMemoryMB = 3000

config.JobType.pyCfgParams = ['noprint']
config.JobType.numCores = 1
config.JobType.allowUndistributedCMSSW = True

##
config.Data.inputDataset = '/GENSIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV/phys_heavyions-test_GEN_SIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV-c85668b2e56683bae82ab438e1f76ee0/USER'
config.Data.inputDBS = 'phys03'
config.Data.unitsPerJob = 1
config.Data.totalUnits = -1
config.Data.splitting = 'FileBased'
config.Data.publication = True
config.Data.outputDatasetTag = 'test_DIGI_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'
config.Data.outLFNDirBase = '/store/group/phys_heavyions/aholterm/mcproduction_g2qqbar/'

config.Site.storageSite = "T2_CH_CERN"