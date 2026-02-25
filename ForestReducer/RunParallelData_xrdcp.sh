#!/bin/bash
source clean.sh
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get parameters
PATHSAMPLE="$1"
OUTPUT="$2"

if [ -z "$PATHSAMPLE" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 <input_path> <output_path> [options]"
    echo "Example: $0 /store/group/... /data00/output/skim --IsData true --IsPP true"
    echo ""
    echo "Options (with defaults):"
    echo "  --IsData <bool>                    (default: true)"
    echo "  --IsPP <bool>                      (default: true)"
    echo "  --PFJetCollection <string>         (default: ak3PFJetAnalyzer/t)"
    echo "  --UseHybrid <bool>                 (default: false)"
    echo "  --MinJetPT <number>                (default: 0)"
    echo "  --Fraction <float>                 (default: 1.0)"
    echo "  --IsDebug <bool>                   (default: false)"
    echo "  --UseTrackVtxInfo <bool>           (default: false)"
    echo "  --MuTrackMatchDRCut <float>        (default: 0.001)"
    echo "  --GenRecoMuonMatchDRCut <float>    (default: 0.03)"
    echo "  --ApplyConstituentMatching <bool>  (default: false)"
    exit 1
fi

### SKIMMER PARAMETERS (with defaults) ###
ISDATA=true
ISPP=true
PFJETS=ak3PFJetAnalyzer/t
MINJETPT=0
FRACTION=1.0
ISDEBUG=false
USETRACKVTXINFO=false
USEHYBRID=false
MUTRACKMATCHDRCUT=0.001
GENRECOMUONMATCHDRCUT=0.03
APPLYCONSTITUENTMATCHING=false

# Parse optional arguments
shift 2  # Remove input_path and output_path from argument list
while [[ $# -gt 0 ]]; do
    case $1 in
        --IsData)
            ISDATA="$2"
            shift 2
            ;;
        --IsPP)
            ISPP="$2"
            shift 2
            ;;
        --PFJetCollection)
            PFJETS="$2"
            shift 2
            ;;
        --UseHybrid)
            USEHYBRID="$2"
            shift 2
            ;;
        --MinJetPT)
            MINJETPT="$2"
            shift 2
            ;;
        --Fraction)
            FRACTION="$2"
            shift 2
            ;;
        --IsDebug)
            ISDEBUG="$2"
            shift 2
            ;;
        --UseTrackVtxInfo)
            USETRACKVTXINFO="$2"
            shift 2
            ;;
        --MuTrackMatchDRCut)
            MUTRACKMATCHDRCUT="$2"
            shift 2
            ;;
        --GenRecoMuonMatchDRCut)
            GENRECOMUONMATCHDRCUT="$2"
            shift 2
            ;;
        --ApplyConstituentMatching)
            APPLYCONSTITUENTMATCHING="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

### OTHER PARAMETERS ###
MAXCORES=50  
NFILES=-1
XRDSERV="root://eoscms.cern.ch/" # eos xrootd server, path should start /store/group...

wait_for_slot() {
    while (( $(jobs -r | wc -l) >= MAXCORES )); do
        # Wait a bit before checking again
        sleep 1
    done
}

rm -rf $OUTPUT &> /dev/null
mkdir -p $OUTPUT
mkdir -p "${OUTPUT}/temp_inputs/"


# Loop through each file in the file list (recursively search all subdirectories)
COUNTER=0
for FILEPATH in $(xrdfs $XRDSERV ls -R $PATHSAMPLE | grep 'HiForest'); do

    if [ $NFILES -gt 0 ] && [ $COUNTER -ge $NFILES ]; then
        break
    fi

    LOCALFILE="${OUTPUT}/temp_inputs/job_${COUNTER}.root"
    rm $LOCALFILE &> /dev/null

    echo "Starting job $COUNTER ($(jobs -r | wc -l) jobs currently running)"
    
    (
        xrdcp -N ${XRDSERV}${FILEPATH} $LOCALFILE
        ${SCRIPTDIR}/Execute --Input "$LOCALFILE" \
        --IsDebug $ISDEBUG \
        --IsData $ISDATA \
        --IsPP $ISPP \
        --UseTrackVtxInfo $USETRACKVTXINFO \
        --useHybrid $USEHYBRID \
        --MuTrackMatchDRCut $MUTRACKMATCHDRCUT \
        --GenRecoMuonMatchDRCut $GENRECOMUONMATCHDRCUT \
        --applyConstituentMatching $APPLYCONSTITUENTMATCHING \
        --Output "$OUTPUT/output_$COUNTER.root" \
        --PFJetCollection $PFJETS \
        --MinJetPT $MINJETPT \
        --Fraction $FRACTION
        rm $LOCALFILE
        echo "FINISHED job $COUNTER: $FILEPATH"
    ) &

    wait_for_slot
    ((COUNTER++))
done
wait

hadd -f $OUTPUT/mergedfile.root $OUTPUT/output_*.root
rm -f $OUTPUT/output_*.root
rm -rf "${OUTPUT}/temp_inputs/"
echo "Processing COMPLETE"