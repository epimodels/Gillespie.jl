using PyCall
const pysces = pyimport("pysces") #import pysces
using Gillespie
using Gadfly
import Random: seed!

mutable struct modelStruct
    model::Union{Nothing, PyObject}
end

mdl = modelStruct(nothing)

# a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
function get_initvar()
    x1 = Vector{Int64}([])
    for i in mdl.model.species
        append!(x1, convert(Int64, eval(Meta.parse("mdl.model." * i))))
    end
    return x1
end

# a `Vector` of `Float64` representing the parameters of the system. #InitPar
function get_initparam()
    x1 = Vector{Float64}([])
    for i in mdl.model.parameters
        append!(x1, eval(Meta.parse("mdl.model." * i)))
    end
    return x1
end

# Stoichiometric matrix
# get the Nmatrix using pysces, convert it to an array, then to an integer array, then find its transpose
function get_matrix()
    return (convert(Matrix{Int64}, mdl.model.Nmatrix.array))'
end

# gets the propensities by parsing through the pysces model and looking for the reactions
# returns a string that represents an array of propensities
function get_propensities()

    reactions = mdl.model.reactions
    output = "["
    
    open(mdl.model.ModelDir * "/" * mdl.model.ModelFile) do f

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
# Would be better practice to avoid strings and instead construct as an expression
macro getF_dd()

    funcString = "function F_dd(x,parms)\n"
    stateString = "    ("
    paramString = "    ("
    
    for i in mdl.model.species
        stateString = stateString * i * ","
    end
    stateString = first(stateString, length(stateString) - 1) * ") = x\n"

    for i in mdl.model.parameters
        paramString = paramString * i * ","
    end
    paramString = first(paramString, length(paramString) - 1) * ") = parms\n"

    propString = get_propensities()

    return Meta.parse(funcString * stateString * paramString * "    " * propString * "end")
end

#@getF_dd

function F_dd(x,parms)
    (S1,S2,S3) = x
    (c1,c2,c3,c4) = parms
    [c1*S1,c2*S1*S1,c3*S2,c4*S2]
end

function set_model(modelName::String)
    mdl.model = pysces.model(modelName, dir="c:\\Pysces\\psc")
end

function ssa_run()

    x0 = get_initvar() # a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
    nu = get_matrix() # a `Matrix` of `Int64`, representing the transitions of the system, organised by row. Stoichiometric Matrix
    parms = get_initparam() # a `Vector` of `Float64` representing the parameters of the system. #InitPar

    # the final simulation time (`Float64`)
    tf = 10.0
    seed!(1234)

    result = ssa(x0,F_dd,nu,parms,tf)
    data = ssa_data(result)
end

set_model("DecayingDimerizing")
ssa_run()
