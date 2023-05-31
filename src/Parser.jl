using PyCall
const pysces = pyimport("pysces") #import pysces

model = pysces.model("DecayingDimerizing", dir="c:\\Pysces\\psc")
species = model.species
reactions = model.reactions
matrix = model.Nmatrix
model.showN()