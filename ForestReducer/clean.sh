rm Execute
rm -f *.png
rm filterEvents
rm MergedOutput.root
rm -rf Output
rm SkimReco.root
rm list.txt
rm -rf output
rm *.txt*
rm SkimReco.root
rm .DS_Store
CURRENTDIR=$PWD
cd /home/$USER/CMSSW_13_2_4/src
cmsenv

cd $CURRENTDIR
echo "CMSSW environment is set up"
cd ../
source SetupAnalysis.sh
cd CommonCode/
make
cd ..
cd $CURRENTDIR
make
rm Skim*.root