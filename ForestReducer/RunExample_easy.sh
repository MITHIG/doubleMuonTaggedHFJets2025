
LOCALFILE="/afs/cern.ch/user/a/aholterm/forestIII/CMSSW_10_6_46/src/HeavyIonsAnalysis/Configuration/test/HiForestMiniAOD.root"
ISDEBUG=false
ISDATA=false
ISPP=true
USETRACKVTXINFO=true
USEHYBRID=true
MUTRACKMATCHDRCUT=0.001
GENRECOMUONMATCHDRCUT=0.03
APPLYCONSTITUENTMATCHING=false
OUTPUT=output
PFJETS="ak3PFJetAnalyzer/t"
MINJETPT=0
FRACTION=1

./Execute --Input "$LOCALFILE" \
        --IsDebug $ISDEBUG \
        --IsData $ISDATA \
        --IsPP $ISPP \
        --UseTrackVtxInfo $USETRACKVTXINFO \
        --useHybrid $USEHYBRID \
        --MuTrackMatchDRCut $MUTRACKMATCHDRCUT \
        --GenRecoMuonMatchDRCut $GENRECOMUONMATCHDRCUT \
        --applyConstituentMatching $APPLYCONSTITUENTMATCHING \
        --Output "output.root" \
        --PFJetCollection $PFJETS \
        --MinJetPT $MINJETPT \
        --Fraction $FRACTION

