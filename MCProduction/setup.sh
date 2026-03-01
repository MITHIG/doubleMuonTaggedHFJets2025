#!/bin/bash

HOMEDIR=$PWD
DO_FILTER=true

cmsrel CMSSW_10_6_29
cmsrel CMSSW_9_4_14_UL_patch1
cmsrel CMSSW_10_6_26

cd CMSSW_10_6_26/src
cmsenv

git cms-init
git cms-addpkg Configuration/Generator
scram b -j8

cp $HOMEDIR/GenFragments/*  Configuration/Generator/python

cd $HOMEDIR

cp crabConfigs/crab_step1_GENSIM.py $HOMEDIR/CMSSW_10_6_26/src/
cp crabConfigs/crab_step2_DIGI.py $HOMEDIR/CMSSW_10_6_29/src/
cp crabConfigs/crab_step3_HLT.py $HOMEDIR/CMSSW_9_4_14_UL_patch1/src/
cp crabConfigs/crab_step4_RECO.py $HOMEDIR/CMSSW_10_6_29/src/
cp crabConfigs/crab_step5_MINIAOD.py $HOMEDIR/CMSSW_10_6_29/src/

