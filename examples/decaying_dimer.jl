using Gillespie
import Random: seed!

# Function dealing with state x and parameters parms
# **F** : a `Function` or a callable type, which itself takes two arguments; x, a `Vector` of `Int64` representing the states, and parms, a `Vector` of `Float64` representing the parameters of the system. In the case of time-varying rates (for algorithms `:jensen` and `:tjm`), there should be a third argument, the time of the system.
function F_dd(x,parms)
    (S1,S2,S3) = x
    (c1,c2,c3,c4) = parms
    [c1*S1,c2*S1*S1,c3*S2,c4*S2]
end

# a `Vector` of `Int64`, representing the initial states of the system.
x0 = [10000,0,0]

# a `Matrix` of `Int64`, representing the transitions of the system, organised by row.
nu = [[-1 0 0];[-2 1 0];[2 -1 0];[0 -1 1]]

# a `Vector` of `Float64` representing the parameters of the system.
parms = [1.0,0.002,0.5,0.04]

# the final simulation time (`Float64`)
tf = 10.0
seed!(1234)

"
There are several named arguments:

- **algo**: the algorithm to use (`Symbol`, either `:gillespie` (default), ':jensen', or ':tjm').
- **max_rate**: the maximum rate (`Float64`, for Jensen's method only).
- **thin**: (`Bool`) whether to thin jumps for Jensens method (default: `true`).
"
result = ssa(x0,F_dd,nu,parms,tf)

data = ssa_data(result)
