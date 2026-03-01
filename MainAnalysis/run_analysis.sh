
source clean.sh

# running analysis over SOFTMVAID-selected skims for consistency + to use older mc samples
INPUT_DATA_HIGHEG="/data00/g2ccbar/data2018/highEGfull.root"
INPUT_DATA_LOWEG="/data00/g2ccbar/data2018/lowEGfull.root"
INPUT_MC="/data00/g2ccbar/mc2018/pythia_0210_softmvaID.root"

chargesel=0
muPt=4.0
pTbins=100,120,160,200,250

### PARALLEL EXECUTION PARAMETERS ###
MAXCORES=3

wait_for_slot() {
    while (( $(jobs -r | wc -l) >= MAXCORES )); do
        sleep 1
    done
}



# EFFICIENCY
./ExecuteEfficiency \
    --Input $INPUT_MC \
    --Output "efficiencies.root" \
    --IsData false \
    --ptBins $pTbins \
    --muPt $muPt \
    --chargeSelection $chargesel \
    --makeplots true \

# we don't run this for data yet. It will be useful to run over data to generate dN/dpT for inclusive jets
# but I am not going to worry about this until it's time to unfold

# MAKE DISTRIBUTIONS
echo "Starting MakeDistros jobs in parallel..."

(
    ./MakeDistros \
        --Input "$INPUT_MC" \
        --Output "mcdistros.root" \
        --IsData false \
        --chargeSelection "$chargesel" \
        --ptBins "$pTbins" \
        --muPt "$muPt" \
        --weightMC true \
        --makeplots true
    echo "FINISHED: mcdistros.root"
) &

wait_for_slot

(
    ./MakeDistros \
        --Input "$INPUT_DATA_HIGHEG" \
        --Output "data_distros_highEG.root" \
        --IsData true \
        --chargeSelection "$chargesel" \
        --DataTrigger 80 \
        --ptBins "$pTbins" \
        --muPt "$muPt" \
        --weightMC false \
        --makeplots true
    echo "FINISHED: data_distros_highEG.root"
) &

wait_for_slot

(
    ./MakeDistros \
        --Input "$INPUT_DATA_LOWEG" \
        --Output "data_distros_lowEG.root" \
        --IsData true \
        --chargeSelection "$chargesel" \
        --DataTrigger 60 \
        --ptBins "$pTbins" \
        --muPt "$muPt" \
        --weightMC false \
        --makeplots true
    echo "FINISHED: data_distros_lowEG.root"
) &

wait

hadd -f data_distros.root data_distros_highEG.root data_distros_lowEG.root
rm -f data_distros_highEG.root data_distros_lowEG.root

#Yield extraction: MC to MC (closure test)
./ExecuteYield \
    --Input "mcdistros.root" \
    --Templates "mcdistros.root" \
    --Output "yields_mc.root" \
    --ptBins $pTbins \
    --variables muDR,mumuZ \
    --kde 1.3,1.1 \
    --fitRangeMin 0.0,0.0 \
    --fitRangeMax 0.6,1.0 \
    --chargeSelection $chargesel \
    --makeplots true \


#Yield Extraction: MC to data
./ExecuteYield \
    --Input "data_distros.root" \
    --Templates "mcdistros.root" \
    --Output "yields.root" \
    --ptBins $pTbins \
    --variables muDR,mumuZ \
    --kde 1.3,1.1 \
    --fitRangeMin 0.0,0.0 \
    --fitRangeMax 0.6,1.0 \
    --chargeSelection $chargesel \
    --makeplots true \
