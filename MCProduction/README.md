
## MCProduction 

This folder contains the ingredients to run both the filtered and unfiltered evtgen private MC production for the g2QQbar analysis. 

```setup.sh``` > A macro to set up the (3) cmssw environments required for this production. It also handles the setup of the different Gen Fragments used for the mc production, and will copy the necessary crab submission configuration files to each CMSSW release 

```runstages.sh``` > A bash script to run the 5 production steps for the MC production. This script will generate each python file required for the MC production using cmsdriver, and will (if specified) also generate a small local miniAOD sample. The Python macros will have unambiguous names like "step1_GEN_SIM.py", or "step3_HLT.py" and these names are already hard-coded into the crab submission scripts. You can configure the content and function of the python files by using the following arguments:

- useNoExec: (bool) if set to true, no local miniAOD production will be done by runstages.sh, only the requisite python macros will be generated
- NEVTS: (int) This is the number of output events each macro is configured to generate. Filter efficiency is already handled in this component for the gen-sim step
- useHerwig: (bool) if true, generates using Herwig instead of pythia
- useDimuonFilter: (bool) if true, uses Matt's dimuon filter. Otherwise generates normally
- useEvtGen: (bool) only if useHerwig is false, can use event gen or not 

```crabConfigs``` contains all of the crab submission files for each step. These will be copied to the corresponding CMSSW environment for use when it is time to submit crab jobs. step 1 -> CMSSW_10_26/src, step 3 -> CMSSW_9_4_14_ULPatch1/src, all others -> CMSSW_10_6_29/src

```GenFragments``` contains all of the python config files for the Gen-Sim step. They're automatically copied to the correc place in CMSSW_10_6_26/src/Generator/python by the setup script. The correct one for the MC you are trying to run is automatically selected by runstages.sh


### Quickstart (should work in AFS): 

```
voms-proxy-init --rfc --voms cms -valid 192:00
git clone https://github.com/MITHIG/doubleMuonTaggedHFJets2025.git 
cmssw-el7
cd doubleMuonTaggedHFJets2025/MCProduction
./setup.sh 
./runstages.sh
```



### Notes 

1. We do not currently use the pileup arguments used in the original 2017 MC campaign as they throw errors: 
--pileup 2017_5TeV_UltraLegacy_PoissonOOTPU \
--pileup_input "dbs:/MinBias_TuneCP5_5TeV-pythia8/RunIISummer20UL17pp5TeVGS-106X_mc2017_realistic_forppRef5TeV_v3-v1/GEN-SIM" \

2. The crab configs will work, but you will need to configure each crab config's input and output datasets before use. Also, since the CMSSW version is vital for the usage of this MC, make sure to run cmsenv before you submit the crab jobs.

3. The number of events you submit for the GEN-SIM crab job step is the number of RAW events before the filter is applied. If you have configured your step1_GEN_SIM.py to accept 1000 events, you will want to generate at least 700 x 1000 events per job to fulfill the filter efficiency. The job will automatically stop if you run over 1000 filtered events, so there is no need to worry about extravagantly large event numbers
