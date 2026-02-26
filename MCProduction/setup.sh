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

cp $HOMEDIR/Pythia8_HardQCD_EvtGen.py  Configuration/Generator/python
cp $HOMEDIR/Pythia8_HardQCD_EvtGen_Filtered.py Configuration/Generator/python

cd $HOMEDIR