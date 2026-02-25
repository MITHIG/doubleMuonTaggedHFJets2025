#!/bin/bash
source clean.sh
rm -rf Output/
mkdir -p Output/

INPUTDIR="/eos/cms/store/group/phys_heavyions/aholterm/g2qqbar/testforest"
#################
## MC pp file ###
#################

./RunParallelMC_xrdcp.sh "$INPUTDIR" "Output" \
        --PFJetCollection "ak3PFJetAnalyzer/t" \
        --UseHybrid false \
        --MinJetPT 0 \
        --Fraction 1.0 \
        --IsDebug false \
        --UseTrackVtxInfo false \
        --MuTrackMatchDRCut 0.001 \
        --GenRecoMuonMatchDRCut 0.03 \
        --ApplyConstituentMatching false


# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running reference comparison...${NC}"

root -l -b -q "compareReference.C(\"Output/mergedfile.root\",\"OutputReference/output_ReferenceMCFileAOD.root\")"

if [ $? -ne 0 ]; then
    echo -e "${RED}Comparison FAILED${NC}"
    exit 1
fi

echo -e "${GREEN}Comparison PASSED${NC}"

