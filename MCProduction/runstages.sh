#!/bin/bash
# NOTE: Run voms-proxy-init --voms cms --valid 168:00 before this script.

NEVTS=10

HOMEDIR=$PWD
echo "HOME DIRECTORY: $HOMEDIR"

#ENTER CMSSW 26 TO RUN GENSIM
cd CMSSW_10_6_26/src

cmsenv
cmsenv

echo "Running step 1: GEN-SIM"

cmsDriver.py Pythia8_HardQCD_EvtGen.py \
  --mc \
  --eventcontent RAWSIM \
  --datatier GEN-SIM \
  --conditions 106X_mc2017_realistic_forppRef5TeV_v3 \
  --beamspot Fixed_EmitRealistic5TeVppCollision2017 \
  --step GEN,SIM \
  --geometry DB:Extended \
  --era Run2_2017_ppRef \
  --fileout file:step1.root \
  --python_filename step1_GEN_SIM.py \
  -n $NEVTS

#cmsRun step1_GEN_SIM.py

mv *.py $HOMEDIR
mv *.root $HOMEDIR
cd $HOMEDIR/CMSSW_10_6_29/src
cmsenv


echo "Running step 2: DIGI"

cmsDriver.py step1 \
  --mc \
  --eventcontent RAWSIM \
  --datatier GEN-SIM-RAW \
  --conditions 106X_mc2017_realistic_forppRef5TeV_v3 \
  --beamspot Fixed_EmitRealistic5TeVppCollision2017 \
  --step DIGI,L1,DIGI2RAW \
  --geometry DB:Extended \
  --era Run2_2017_ppRef \
  --filein file:$HOMEDIR/step1.root \
  --fileout file:step2.root \
  --python_filename step2_DIGI.py \
  -n $NEVTS

#cmsRun step2_DIGI.py

mv *.py $HOMEDIR
mv *.root $HOMEDIR
cd $HOMEDIR/CMSSW_9_4_14_UL_patch1/src
cmsenv
cmsenv

echo "Running step 3: HLT"

# NOT INCLUDED IN THIS STEP FOR NOW, WAITING FOR FEEDBACK FROM CLAYTON
# --pileup 2017_5TeV_UltraLegacy_PoissonOOTPU \
# --pileup_input "dbs:/MinBias_TuneCP5_5TeV-pythia8/RunIISummer20UL17pp5TeVGS-106X_mc2017_realistic_forppRef5TeV_v3-v1/GEN-SIM" \

cmsDriver.py step2 \
  --mc \
  --eventcontent RAWSIM \
  --datatier GEN-SIM-RAW \
  --conditions 94X_mc2017_realistic_forppRef5TeV_v2 \
  --step HLT:PRef \
  --geometry DB:Extended \
  --era Run2_2017_ppRef \
  --customise Configuration/DataProcessing/Utils.addMonitoring \
  --customise_commands 'process.source.bypassVersionCheck = cms.untracked.bool(True)' \
  --filein file:$HOMEDIR/step2.root \
  --fileout file:step3.root \
  --python_filename step3_HLT.py \
  -n $NEVTS

#cmsRun step3_HLT.py

mv *.py $HOMEDIR
mv *.root $HOMEDIR
cd $HOMEDIR/CMSSW_10_6_29/src
cmsenv
cmsenv


echo "Running step 4: RECO"

cmsDriver.py step3 \
  --mc \
  --eventcontent AODSIM \
  --datatier AODSIM \
  --conditions 106X_mc2017_realistic_forppRef5TeV_v3 \
  --step RAW2DIGI,L1Reco,RECO \
  --geometry DB:Extended \
  --era Run2_2017_ppRef \
  --filein file:$HOMEDIR/step3.root \
  --fileout file:step4_AOD.root \
  --python_filename step4_RECO.py \
  -n $NEVTS

#cmsRun step4_RECO.py

mv *.py $HOMEDIR
mv *.root $HOMEDIR

echo "Running step 5: MINIAOD"

cmsDriver.py step4_AOD \
  --mc \
  --eventcontent MINIAODSIM \
  --datatier MINIAODSIM \
  --conditions 106X_mc2017_realistic_forppRef5TeV_v3 \
  --step PAT \
  --runUnscheduled \
  --geometry DB:Extended \
  --era Run2_2017_ppRef \
  --procModifiers run2_miniAOD_UL \
  --filein file:$HOMEDIR/step4_AOD.root \
  --fileout file:miniAOD.root \
  --python_filename step5_MINIAOD.py \
  -n $NEVTS

#cmsRun step5_MINIAOD.py

mv *.py $HOMEDIR
mv *.root $HOMEDIR
cd $HOMEDIR

echo "DONE WITH ALL STEPS!"