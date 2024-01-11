import matplotlib.pyplot as plt
import matplotlib.cbook as cbook

import numpy as np
import pandas as pd
plt.rcParams["figure.figsize"] = [7.00, 3.50]
plt.rcParams["figure.autolayout"] = True
columns = ["A", "B", "C", "D", "E"]
df = pd.read_csv('~/Stochpy/DecayingDimerizing.psc_species_timeseries1.txt', usecols=columns)
print(df.columns)