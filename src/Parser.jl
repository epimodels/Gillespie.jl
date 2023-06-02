using PyCall
const pysces = pyimport("pysces") #import pysces
using Gillespie
import Random: seed!

model = pysces.model("DecayingDimerizing", dir="c:\\Pysces\\psc") #PyObject
species = model.species #Tuple{String, String, String}
reactions = model.reactions #Tuple{4, String}
parameters = model.parameters
println(parameters)
println(species)
println(reactions)
# print(model.k1)

# a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
x1 = Vector{Int64}([])
for i in species
    append!(x1, convert(Int64, eval(Meta.parse("model." * i))))
end

print(typeof(x1))
print(x1)

# Stoichiometric matrix
# get the Nmatrix using pysces, convert it to an array, then to an integer array, then find its transpose
# nu = (convert(Matrix{Int64}, model.Nmatrix.array))'

# model.showN()

# the final simulation time (`Float64`)
# tf = 10.0
# seed!(1234)
