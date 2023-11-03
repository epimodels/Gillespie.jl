import stochpy
import pysces
import numpy as np

smod = stochpy.SSA()
smod.Model('BirthDeath.psc')
smod.DoStochSim(trajectories=1000)
smod.Export2File()