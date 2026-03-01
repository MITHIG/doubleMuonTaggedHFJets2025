from CRABClient.UserUtilities import config
config = config()
config.General.transferOutputs = True
config.General.requestName = 'RECO_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'

config.JobType.psetName = 'step4_RECO.py'
config.JobType.pluginName = 'Analysis'
config.JobType.maxMemoryMB = 3000

config.JobType.pyCfgParams = ['noprint']
config.JobType.numCores = 1
config.JobType.allowUndistributedCMSSW = True

##
# TODO: Update with actual step 3 output dataset after HLT completes
config.Data.inputDataset = '/GENSIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV/phys_heavyions-test_HLT_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV-67ce682366d0056f3501df2a2674d78a/USER'
config.Data.inputDBS = 'phys03'
config.Data.unitsPerJob = 1
config.Data.totalUnits = -1
config.Data.splitting = 'FileBased'
config.Data.publication = True
config.Data.outputDatasetTag = 'test_RECO_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'
config.Data.outLFNDirBase = '/store/group/phys_heavyions/aholterm/mcproduction_g2qqbar/'

config.Site.storageSite = "T2_CH_CERN"