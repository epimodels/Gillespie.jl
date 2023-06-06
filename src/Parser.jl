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

# gets the propensities by parsing through the pysces model and looking for the reactions
# returns a string that represents an array of propensities
function getPropensities()

    reactions = model.reactions
    output = "["
    
    open(model.ModelDir * "/" * model.ModelFile) do f

        current_reaction = 1
    
        # read till end of file
        while (! eof(f))
            line = readline(f) # read a new / next line for every iteration
            if (occursin(reactions[current_reaction], line))
                readline(f)
                output = output * readline(f) * ","
                if (reactions[current_reaction] == last(reactions))
                    break
                end
                current_reaction += 1
            end
        end
    end
    return replace(first(output, length(output) - 1) * "]\n"," " => "") # remove last comma, add closing bracket, remove spaces
end

# Constructs expression for propensities function
macro getF_dd()
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

    propString = getPropensities()

    return Meta.parse(funcString * stateString * paramString * "    " * propString * "end")
end

@getF_dd

function simulate()
    x0 = getInitVar(model) # a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
    nu = getMatrix(model) # a `Matrix` of `Int64`, representing the transitions of the system, organised by row. Stoichiometric Matrix
    parms = getInitParam(model) # a `Vector` of `Float64` representing the parameters of the system. #InitPar

    # the final simulation time (`Float64`)
    tf = 10.0
    seed!(1234)

    result = ssa(x0,F_dd,nu,parms,tf)
    data = ssa_data(result)
end

simulate()
