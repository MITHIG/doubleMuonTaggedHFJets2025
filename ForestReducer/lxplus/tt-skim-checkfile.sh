#!/bin/bash

if [[ $# -ne 16 ]]; then
    echo "usage: ./tt-skim-checkfile.sh [executable file] [input file] [output dir] [output filename] [release] [IsData] [MinJetPT] [IsPP] [UseHybrid] [IsDebug] [UseTrackVtxInfo] [Fraction] [MuTrackMatchDRCut] [GenRecoMuonMatchDRCut] [applyConstituentMatching] [PFJetCollection]"
    exit 1
fi

EXEFILE=$1
INFILE=$2
DESTINATION=$3
OUTFILE=$4
CRELEASE=$5
IsData=$6
MinJetPT=$7
IsPP=$8
USEHYBRID=$9
IsDebug=${10}
UseTrackVtxInfo=${11}
Fraction=${12}
MuTrackMatchDRCut=${13}
GenRecoMuonMatchDRCut=${14}
applyConstituentMatching=${15}
PFJetCollection=${16}

echo "SCRAM_ARCH:          "$SCRAM_ARCH
echo "PWD:                 "$PWD
echo "_CONDOR_SCRATCH_DIR: "$_CONDOR_SCRATCH_DIR
echo "hostname:            "$(hostname)
echo "INFILE:              "$INFILE
echo "DESTINATION:         "$DESTINATION

# tar -xzvf corr.tar.gz
source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project CMSSW $CRELEASE

[[ -d $CRELEASE/src ]] && {
    cd $CRELEASE/src
    eval `scram runtime -sh`
    cd ../../

    root --version

    input_file=$INFILE
    xrdcp $INFILE .
    [[ -f $PWD/${INFILE##*/} ]] && input_file=$PWD/${INFILE##*/} || echo "xrdcp failed."

    set -x

    ./Execute --Input $input_file \
              --Output $OUTFILE \
              --IsDebug $IsDebug \
              --IsData $IsData \
              --IsPP $IsPP \
              --UseTrackVtxInfo $UseTrackVtxInfo \
              --useHybrid $USEHYBRID \
              --MinJetPT $MinJetPT \
              --MuTrackMatchDRCut $MuTrackMatchDRCut \
              --GenRecoMuonMatchDRCut $GenRecoMuonMatchDRCut \
              --applyConstituentMatching $applyConstituentMatching \
              --PFJetCollection $PFJetCollection \
              --Fraction $Fraction
    
    ls
    
    if [[ $(wc -c $OUTFILE | awk '{print $1}') -gt 700 ]] ; then
        # xrdcp
        SRM_PREFIX="/eos/cms/" ; SRM_PATH=${DESTINATION#${SRM_PREFIX}} ;
        xrdcp ${OUTFILE} root://eoscms.cern.ch//${SRM_PATH}/$OUTFILE
    fi
    set +x
}

rm -rf $EXEFILE $CRELEASE
rm $PWD/${INFILE##*/}
rm $OUTFILE
