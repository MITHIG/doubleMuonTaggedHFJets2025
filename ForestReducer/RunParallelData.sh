#!/bin/bash
MAXCORES=20
SAMPLEID=0
source clean.sh

ISDEBUG=false
ISDATA=true
ISPP=true
USETRACKVTXINFO=false
USEHYBRID=false
MUTRACKMATCHDRCUT=0.001
GENRECOMUONMATCHDRCUT=0.03
APPLYCONSTITUENTMATCHING=false
PFJETCOLLECTION=ak3PFJetAnalyzer/t
MINJETPT=0
FRACTION=1.0

echo "Running on sample ID: $SAMPLEID"

if [ "$SAMPLEID" -eq 0 ]; then
    NAMEData="/data00/g2ccbar/data2018/skim_120525_0"
    FOLDER="/eos/cms/store/group/phys_heavyions/aholterm/g2qqbar/HighEGJet/crab_btagged_and_svtagged_jets_DATA_HFfindersC/251202_223300/0000"
fi
echo "Running on sample: $NAMEData"
echo "Running on folder: $FOLDER"

OUTPUTData="outputData"
counter=0
filelistData="filelist.txt"
MERGEDOUTPUTData="$NAMEData"
MERGEDOUTPUTDataFILE="$NAMEData/mergedfile.root"

rm -rf $MERGEDOUTPUTData
mkdir $MERGEDOUTPUTData
cp ./RunParallelData.sh $MERGEDOUTPUTData/.

# Function to monitor active processes
wait_for_slot() {
    while (( $(jobs -r | wc -l) >= MAXCORES )); do
        # Wait a bit before checking again
        sleep 1
    done
}

ls $FOLDER/HiForestMiniAOD_*.root > $filelistData
echo "File list created successfully: $filelistData"

# Check if the filelist is empty
if [[ ! -s "$filelistData" ]]; then
    echo "No matching files found in Samples directory."
    exit 1
fi

echo "File list created successfully: $filelistData"
rm -rf $OUTPUTData
mkdir $OUTPUTData
# Loop through each file in the file list
while IFS= read -r file; do
            echo "Processing $file"
            ./Execute --Input "$file" \
            --IsDebug $ISDEBUG \
            --IsData $ISDATA \
            --IsPP $ISPP \
            --UseTrackVtxInfo $USETRACKVTXINFO \
            --useHybrid $USEHYBRID \
            --MuTrackMatchDRCut $MUTRACKMATCHDRCUT \
            --GenRecoMuonMatchDRCut $GENRECOMUONMATCHDRCUT \
            --applyConstituentMatching $APPLYCONSTITUENTMATCHING \
            --Output "$OUTPUTData/output_$counter.root" \
            --PFJetCollection $PFJETCOLLECTION \
            --MinJetPT $MINJETPT --Fraction $FRACTION & 
    ((counter++))
    wait_for_slot
done < "$filelistData"
wait 

hadd $MERGEDOUTPUTDataFILE $OUTPUTData/output_*.root
echo "All done Data!"
echo "Merged output file: $MERGEDOUTPUTMCFILE"
