using PyCall
const pysces = pyimport("pysces") #import pysces
using Gillespie
using Gadfly
import Random: seed!

model = pysces.model("DecayingDimerizing", dir="c:\\Pysces\\psc") #PyObject

# a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
function getInitVar(model)
    species = model.species
    x1 = Vector{Int64}([])
    for i in species
        append!(x1, convert(Int64, eval(Meta.parse("model." * i))))
    end
    return x1
end

# a `Vector` of `Float64` representing the parameters of the system. #InitPar
function getInitParam(model)
    parameters = model.parameters
    x1 = Vector{Float64}([])
    for i in parameters
        append!(x1, eval(Meta.parse("model." * i)))
    end
    return x1
end

# Stoichiometric matrix
# get the Nmatrix using pysces, convert it to an array, then to an integer array, then find its transpose
function getMatrix(model)
    return (convert(Matrix{Int64}, model.Nmatrix.array))'
end

function getF_dd()
    species = model.species
    parameters = model.parameters

    funcString = "function F_dd(x,parms)\n"
    stateString = "    ("
    paramString = "    ("
    

    for i in species
        stateString = stateString * i * ","
    end
    stateString = first(stateString, length(stateString) - 1) * ") = x\n"

    for i in parameters
        paramString = paramString * i * ","
    end
    paramString = first(paramString, length(paramString) - 1) * ") = parms\n"
end

# Function dealing with state x and parameters parms
# **F** : a `Function` or a callable type, which itself takes two arguments; x, a `Vector` of `Int64` representing the states, and parms, a `Vector` of `Float64` representing the parameters of the system. In the case of time-varying rates (for algorithms `:jensen` and `:tjm`), there should be a third argument, the time of the system.
function F_dd(x,parms)
    (S1,S2,S3) = x
    (c1,c2,c3,c4) = parms
    [c1*S1,c2*S1*S1,c3*S2,c4*S2]
end

function simulate()
    x0 = getInitVar(model) # a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
    nu = getMatrix(model) # a `Matrix` of `Int64`, representing the transitions of the system, organised by row. Stoichiometric Matrix
    parms = getInitParam(model) # a `Vector` of `Float64` representing the parameters of the system. #InitPar

    # the final simulation time (`Float64`)
    tf = 10.0
    seed!(1234)

    result = ssa(x0,F_dd,nu,parms,tf)
    data = ssa_data(result)
    print(data)
end

getF_dd()