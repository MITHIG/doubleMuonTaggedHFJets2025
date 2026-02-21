#!/bin/bash
source clean.sh
rm -rf Output/
mkdir -p Output/

if [ -d "inputTest" ]; then
    echo "Directory inputTest exists."
else
    echo "Directory inputTest does not exist. Please create it and add the necessary files."
    exit 1
fi

if [ ! -f "inputTest/ReferenceMCFileAOD.root" ]; then
    echo "Required input file inputTest/ReferenceMCFileAOD.root does not exist. Please add it before running this script."
    exit 1
fi
#################
## MC pp file ###
#################

./Execute \
    --Input inputTest/ReferenceMCFileAOD.root \
    --IsData false \
    --IsPP true \
    --svtx true \
    --Output Output/outputSkimMCtest.root \
    --MinJetPT 30 \
    --Fraction 1.00 \
    --useHybrid false \
    --PFJetCollection ak3PFJetAnalyzer/t


# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running reference comparison...${NC}"

root -l -b -q "compareReference.C(\"Output/outputSkimMCtest.root\",\"OutputReference/output_ReferenceMCFileAOD.root\")"

if [ $? -ne 0 ]; then
    echo -e "${RED}Comparison FAILED${NC}"
    exit 1
fi

echo -e "${GREEN}Comparison PASSED${NC}"

