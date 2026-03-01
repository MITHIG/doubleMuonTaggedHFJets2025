import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *

from GeneratorInterface.EvtGenInterface.EvtGenSetting_cff import *
# If you want the default EvtGen decay settings too, you can also import:
# from GeneratorInterface.EvtGenInterface.EvtGenSetting_cff import EvtGenExtraParticles

_generator = cms.EDFilter("Pythia8GeneratorFilter",
    comEnergy = cms.double(5020.0),
    filterEfficiency = cms.untracked.double(1.0),
    maxEventsToPrint = cms.untracked.int32(0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    pythiaPylistVerbosity = cms.untracked.int32(0),

    # --- EvtGen hookup ---
    ExternalDecays = cms.PSet(
        EvtGen130 = cms.untracked.PSet(
            decay_table = cms.string(
                'GeneratorInterface/EvtGenInterface/data/DECAY_2020_NOLONGLIFE.DEC'
            ),
            operates_on_particles = cms.vint32(),  # leave empty unless you know you need it
            particle_property_file = cms.FileInPath(
                'GeneratorInterface/EvtGenInterface/data/evt_2020.pdl'
            ),

            # Your custom decay(s)
#            user_decay_file = cms.vstring(
#                'GeneratorInterface/ExternalDecays/data/D0_Kpi.dec'
#            ),
#            list_forced_decays = cms.vstring('myD0', 'myanti-D0'),

            convertPythiaCodes = cms.untracked.bool(False),
        ),
        parameterSets = cms.vstring('EvtGen130')
    ),

    PythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CP5SettingsBlock,
        processParameters = cms.vstring(
            'HardQCD:all = on',
            'PhaseSpace:pTHatMin = 15.',
            'PhaseSpace:pTHatMax = 1200.',  # upper bound for weighted pthat
            'PhaseSpace:bias2Selection = on',
            'PhaseSpace:bias2SelectionPow = 4.5',
            'PhaseSpace:bias2SelectionRef = 15.',
        ),
        parameterSets = cms.vstring(
            'pythia8CommonSettings',
            'pythia8CP5Settings',
            'processParameters',
        ),
    )
)

# Add any extra particles EvtGen may need (common pattern in CMSSW)
_generator.PythiaParameters.processParameters.extend(EvtGenExtraParticles)

from GeneratorInterface.Core.ExternalGeneratorFilter import ExternalGeneratorFilter
generator = ExternalGeneratorFilter(_generator)

ProductionFilterSequence = cms.Sequence(generator)
