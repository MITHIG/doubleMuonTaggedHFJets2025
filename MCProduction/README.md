
## MCProduction 

This folder contains the ingredients to run both the filtered and unfiltered evtgen private MC production for the g2QQbar analysis. 

```Pythia_HardQCD_EvtGen.py``` > Pythia generation file with correct EvtGen setup

```Pythia_HardQCD_EvtGen_Filtered.py``` > Same as above with Matt's dimuon filter

```setup.sh``` > A macro to set up the (3) cmssw environments required for this production.

```runstages.sh``` > A bash script to run the 5 production steps for the "unfiltered" pythia data production

```runstages_filtered.sh``` > A script to run the 5 production steps for the "filtered" pythia data production. The primary difference is that it uses the "filtered" .py file. Additionally, it generates far more events in the GEN-SIM step to compensate for the ~0.0014 efficiency of the dimuon filter. 

### Quickstart (should work in AFS): 

```
voms-proxy-init --rfc --voms cms -valid 192:00
git clone https://github.com/MITHIG/doubleMuonTaggedHFJets2025.git 
cmssw-el7
cd doubleMuonTaggedHFJets2025/MCProduction
./setup.sh 
./runstages_filtered.sh #(or ./runstages to your preference)
```



### Notes 

1. We do not currently use the pileup arguments used in the original 2017 MC campaign as they throw errors: 
--pileup 2017_5TeV_UltraLegacy_PoissonOOTPU \
--pileup_input "dbs:/MinBias_TuneCP5_5TeV-pythia8/RunIISummer20UL17pp5TeVGS-106X_mc2017_realistic_forppRef5TeV_v3-v1/GEN-SIM" \

2. Note that running cmssw-el7 will automatically send you to the top of your lxplus home directory. This can be confusing if you try to build this inside of another folder. 

3. Once setup.sh is run, you can run the "runstages" commands to your heart's content, with the understanding that miniaod + intermediate files will be overwritten unless you tweak the naming in the script.


