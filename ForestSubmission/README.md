Foresting setup + easy run instructions

Run this code block in AFS workspace.
```
cmssw-el7
cmsrel CMSSW_10_6_46
cd CMSSW_10_6_46/src/
cmsenv
git cms-merge-topic AHoltermann:full_cmssw_029126 
git clone -b 10XX_miniAOD_from_14XX https://github.com/boundino/Bfinder.git --depth 1
scram b -j8
voms-proxy-init --voms cms
cmsRun HeavyIonsAnalysis/Configuration/test/recipe5_MC.py

```

The important foresting configurations: recipe5_MC.py, recipe5_DATA.py will be updated both in the cmssw fork as well as this repo for easy inspection.

The relevant CMSSW fork branch is added as a submodule in the "cmssw_submodule" directory.
