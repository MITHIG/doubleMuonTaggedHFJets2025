import FWCore.ParameterSet.Config as cms



generator = cms.EDFilter("Herwig7GeneratorFilter",
    configFiles = cms.vstring(),
    crossSection = cms.untracked.double(-1),
    dataLocation = cms.string('${HERWIGPATH:-6}'),
    eventHandlers = cms.string('/Herwig/EventHandlers'),
    filterEfficiency = cms.untracked.double(1.0),
    generatorModule = cms.string('/Herwig/Generators/EventGenerator'),
    herwig7CH3AlphaS = cms.vstring(
        'cd /Herwig/Shower',
        'set AlphaQCD:AlphaIn 0.118',
        'cd /'
    ),

    herwig7CH3MPISettings = cms.vstring(
        'set /Herwig/Hadronization/ColourReconnector:ReconnectionProbability 0.4712',
        'set /Herwig/UnderlyingEvent/MPIHandler:pTmin0 3.04',
        'set /Herwig/UnderlyingEvent/MPIHandler:InvRadius 1.284',
        'set /Herwig/UnderlyingEvent/MPIHandler:Power 0.1362'
    ),
    herwig7CH3PDF = cms.vstring(
        'cd /Herwig/Partons',
        'create ThePEG::LHAPDF PDFSet_nnlo ThePEGLHAPDF.so',
        'set PDFSet_nnlo:PDFName NNPDF31_nnlo_as_0118.LHgrid',
        'set PDFSet_nnlo:RemnantHandler HadronRemnants',
        'set /Herwig/Particles/p+:PDF PDFSet_nnlo',
        'set /Herwig/Particles/pbar-:PDF PDFSet_nnlo',
        'set /Herwig/Partons/PPExtractor:FirstPDF  PDFSet_nnlo',
        'set /Herwig/Partons/PPExtractor:SecondPDF PDFSet_nnlo',
        'set /Herwig/Shower/ShowerHandler:PDFA PDFSet_nnlo',
        'set /Herwig/Shower/ShowerHandler:PDFB PDFSet_nnlo',
        'create ThePEG::LHAPDF PDFSet_lo ThePEGLHAPDF.so',
        'set PDFSet_lo:PDFName NNPDF31_lo_as_0130.LHgrid',
        'set PDFSet_lo:RemnantHandler HadronRemnants',
        'set /Herwig/Shower/ShowerHandler:PDFARemnant PDFSet_lo',
        'set /Herwig/Shower/ShowerHandler:PDFBRemnant PDFSet_lo',
        'set /Herwig/Partons/MPIExtractor:FirstPDF PDFSet_lo',
        'set /Herwig/Partons/MPIExtractor:SecondPDF PDFSet_lo',
        'cd /'
    ),
    herwig7StableParticlesForDetector = cms.vstring(
        'set /Herwig/Decays/DecayHandler:MaxLifeTime 10*mm',
        'set /Herwig/Decays/DecayHandler:LifeTimeOption Average'
    ),
    hw_PSWeights_settings = cms.vstring(
        'cd /',
        'cd /Herwig/Shower',
        'do ShowerHandler:AddVariation RedHighAll 1.141 1.141  All',
        'do ShowerHandler:AddVariation RedLowAll 0.707 0.707 All',
        'do ShowerHandler:AddVariation DefHighAll 2 2 All',
        'do ShowerHandler:AddVariation DefLowAll 0.5 0.5 All',
        'do ShowerHandler:AddVariation ConHighAll 4 4 All',
        'do ShowerHandler:AddVariation ConLowAll 0.25 0.25 All',
        'do ShowerHandler:AddVariation RedHighHard 1.141 1.141  Hard',
        'do ShowerHandler:AddVariation RedLowHard 0.707 0.707 Hard',
        'do ShowerHandler:AddVariation DefHighHard 2 2 Hard',
        'do ShowerHandler:AddVariation DefLowHard 0.5 0.5 Hard',
        'do ShowerHandler:AddVariation ConHighHard 4 4 Hard',
        'do ShowerHandler:AddVariation ConLowHard 0.25 0.25 Hard',
        'do ShowerHandler:AddVariation RedHighSecondary 1.141 1.141  Secondary',
        'do ShowerHandler:AddVariation RedLowSecondary 0.707 0.707 Secondary',
        'do ShowerHandler:AddVariation DefHighSecondary 2 2 Secondary',
        'do ShowerHandler:AddVariation DefLowSecondary 0.5 0.5 Secondary',
        'do ShowerHandler:AddVariation ConHighSecondary 4 4 Secondary',
        'do ShowerHandler:AddVariation ConLowSecondary 0.25 0.25 Secondary',
        'set SplittingGenerator:Detuning 2.0',
        'cd /'
    ),
    hw_user_settings = cms.vstring(
        'cd /',
        'read snippets/PPCollider.in', 
        'cd /Herwig/EventHandlers',
        'set /Herwig/EventHandlers/EventHandler:LuminosityFunction:Energy 5020.0', 
        #'set EventHandler:LuminosityFunction:Energy 5020.0',
        'cd /',
        #'read snippets/PPCollider.in',
        'mkdir /Herwig/Weights',
        'cd /Herwig/Weights',
        'create ThePEG::ReweightMinPT reweightMinPT ReweightMinPT.so',
        'cd /Herwig/MatrixElements/',
        'insert SubProcess:MatrixElements[0] MEQCD2to2',
        'insert SubProcess:Preweights[0] /Herwig/Weights/reweightMinPT',
        'cd /',
        'set /Herwig/Cuts/JetKtCut:MinKT 15.*GeV',
        'set /Herwig/Cuts/JetKtCut:MaxKT 5000.*GeV',
        'set /Herwig/Cuts/Cuts:MHatMin  0.0*GeV',
        'set /Herwig/Cuts/Cuts:X1Min    1e-07',
        'set /Herwig/Cuts/Cuts:X2Min    1e-07',
        'set /Herwig/Cuts/MassCut:MinM  0.0*GeV',
        'set /Herwig/Weights/reweightMinPT:Power 4.5',
        'set /Herwig/Weights/reweightMinPT:Scale 15*GeV'
    ),
    parameterSets = cms.vstring(
        'herwig7CH3PDF',
        'herwig7CH3AlphaS',
        'herwig7CH3MPISettings',
        'hw_PSWeights_settings',
        'herwig7StableParticlesForDetector',
        'hw_user_settings'
    ),
    repository = cms.string('${HERWIGPATH}/HerwigDefaults.rpo'),
    run = cms.string('InterfaceMatchboxTest'),
    runModeList = cms.untracked.string('read,run')
)


mumugenfilter = cms.EDFilter("MCParticlePairFilter",
                             Status = cms.untracked.vint32(1, 1),
                             MinPt = cms.untracked.vdouble(2.5, 2.5),
                             MinP = cms.untracked.vdouble(2.5, 2.5),
                             MaxEta = cms.untracked.vdouble(3.0, 3.0),
                             MinEta = cms.untracked.vdouble(-3.0, -3.0),
                             MaxDeltaR = cms.untracked.double(0.8), # assumed safe for R=0.4 jets
                             ParticleCharge = cms.untracked.int32(0), # accept same sign
                             ParticleID1 = cms.untracked.vint32(13),
                             ParticleID2 = cms.untracked.vint32(13)
)

ProductionFilterSequence = cms.Sequence(generator*mumugenfilter)
