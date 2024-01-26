using Gadfly, CSV, DataFrames
using Gillespie, Random
using Distributions, Distributed
import Random: seed!

include("Models.jl")

# Does a sequence of gamma simulations based on a given array, outerjoining x17 of each by time
# Should probably use sparse matrices
# Embarassingly parallel, so should use Distributed.jl
function GammaDistribution(vector::Vector{Float64})
    df = DataFrame(time = [])
    for i in vector
        df1 = select!(Gamma(i), :time, :x17)
        df = outerjoin(df, df1; on=:time, makeunique=true)
    end
    return df
end

#CSV.write(dirname(pwd()) * "/output/export_df.csv", df)
function Driver(f::Function, iterations::Int64)
    for i in 1:iterations
        f()
    end
end

function Driver(f::Function, iterations::Int64, tf::Float64, seed::Int64)
    for i in 1:iterations
        f(tf, seed)
    end
end

function Printer(iterations::Int64, f::Function, location::String, name::String)
    for i in 1:iterations
        TLR = seed!(1234)
        CSV.write(dirname(pwd()) * "/Gillespie/outputs/julia_outputs/DecayingDimerizing/" * name * string(i) * ".csv", DecayingDimerizing(TLR))
    end
end

#GammaDistribution([0.1, 0.2, 0.3, 0.4, 0.5])
#CSV.write(dirname(pwd()) * "/Gillespie/outputs/julia_outputs/DecayingDimerizing/export_df.csv", DecayingDimerizing())

Printer(20, DecayingDimerizing, "/Gillespie/outputs/julia_outputs/DecayingDimerizing/", "DecayingDimerizing")