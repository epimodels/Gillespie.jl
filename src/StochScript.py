import stochpy
import pysces
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import pandas as pd

# Do n simulations, group S1, S2, S3. Do multiple linear regression on them. 

smod = stochpy.SSA()
smod.Model('DecayingDimerizing.psc')
smod.DoStochSim(trajectories=3)

smod.Export2File()
read_file = pd.read_csv(r'~/Stochpy/DecayingDimerizing.psc_species_timeseries1.txt')
read_file.to_csv(r'~/Stochpy/DecayingDimerizing1.csv', index=None)
