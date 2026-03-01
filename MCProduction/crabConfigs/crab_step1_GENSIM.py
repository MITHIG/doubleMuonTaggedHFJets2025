from CRABClient.UserUtilities import config
config = config()
config.General.transferOutputs = True
config.General.requestName = 'GENSIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'

config.JobType.psetName = 'step1_GEN_SIM.py'
config.JobType.pluginName = 'PrivateMC'
config.JobType.maxMemoryMB = 3000

config.JobType.pyCfgParams = ['noprint']
config.JobType.numCores = 1
config.JobType.allowUndistributedCMSSW = True

##
config.Data.outputPrimaryDataset = 'GENSIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'
config.Data.splitting = 'EventBased'
config.Data.unitsPerJob = 100000  # GENERATED events per job (before filter)
config.Data.totalUnits = 1000000  # total GENERATED events (adjust for desired output)
config.Data.publication = True
config.Data.outputDatasetTag = 'test_GEN_SIM_DIMU_EVTGEN_Pythia8_HardQCD_Pthat15_TuneCP5_5362GeV'
config.Data.outLFNDirBase = '/store/group/phys_heavyions/aholterm/mcproduction_g2qqbar/'

config.Site.storageSite = "T2_CH_CERN"
