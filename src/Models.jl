using Gadfly
using Gillespie
using CSV
using DataFrames
import Random: seed!

function Gamma()
    # **F** : a `Function` or a callable type, which itself takes two arguments; x, a `Vector` of `Int64` representing the states, and parms, a `Vector` of `Float64` representing the parameters of the system. In the case of time-varying rates (for algorithms `:jensen` and `:tjm`), there should be a third argument, the time of the system.
    function F_dd(x,parms)
        (N_u1,N_c1,N_u2,N_c2,N_u3,N_c3,N_u4,N_c4,N_u5,N_c5,N_u6,N_c6,D_u,D_c,P_u1,P_c1,Acquisition,P_u2,P_c2,P_u3,P_c3,P_u4,P_c4,P_u5,P_c5,P_u6,P_c6) = x
        (rho_N,rho_D,sigma,psi,gamma,theta,nu,iota_N,iota_D,tau_N,tau_D,mu) = parms
        [rho_N * sigma * N_u1 * (P_c1 / (P_c1 + P_u1)) * gamma,rho_N * sigma * N_u1 * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),rho_N * sigma * N_u1 * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),rho_N * sigma * N_u1 * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),rho_N * sigma * N_u1 * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),rho_N * sigma * N_u1 * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),N_c1 * iota_N,N_c1 * tau_N * (P_c1 / (P_c1 + P_u1)) * gamma,N_c1 * tau_N * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c1 * tau_N * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c1 * tau_N * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c1 * tau_N * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c1 * tau_N * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u2 * (P_c2 / (P_c2 + P_u2)) * gamma,rho_N * sigma * N_u2 * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),rho_N * sigma * N_u2 * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),rho_N * sigma * N_u2 * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),rho_N * sigma * N_u2 * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u2 * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),N_c2 * iota_N,N_c2 * tau_N * (P_c2 / (P_c2 + P_u2)) * gamma,N_c2 * tau_N * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),N_c2 * tau_N * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c2 * tau_N * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c2 * tau_N * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c2 * tau_N * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u3 * (P_c3 / (P_c3 + P_u3)) * gamma,rho_N * sigma * N_u3 * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),rho_N * sigma * N_u3 * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),rho_N * sigma * N_u3 * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u3 * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),rho_N * sigma * N_u3 * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c3 * iota_N,N_c3 * tau_N * (P_c3 / (P_c3 + P_u3)) * gamma,N_c3 * tau_N * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c3 * tau_N * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),N_c3 * tau_N * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c3 * tau_N * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c3 * tau_N * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u4 * (P_c4 / (P_c4 + P_u4)) * gamma,rho_N * sigma * N_u4 * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),rho_N * sigma * N_u4 * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u4 * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),rho_N * sigma * N_u4 * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),rho_N * sigma * N_u4 * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c4 * iota_N,N_c4 * tau_N * (P_c4 / (P_c4 + P_u4)) * gamma,N_c4 * tau_N * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c4 * tau_N * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c4 * tau_N * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),N_c4 * tau_N * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c4 * tau_N * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u5 * (P_c5 / (P_c5 + P_u5)) * gamma,rho_N * sigma * N_u5 * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u5 * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),rho_N * sigma * N_u5 * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),rho_N * sigma * N_u5 * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),rho_N * sigma * N_u5 * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c5 * iota_N,N_c5 * tau_N * (P_c5 / (P_c5 + P_u5)) * gamma,N_c5 * tau_N * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c5 * tau_N * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c5 * tau_N * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c5 * tau_N * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),N_c5 * tau_N * (P_c6 / (P_c6 + P_u6)) * ((1 - gamma) / 5),rho_N * sigma * N_u6 * (P_c6 / (P_c6 + P_u6)) * gamma,rho_N * sigma * N_u6 * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),rho_N * sigma * N_u6 * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),rho_N * sigma * N_u6 * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),rho_N * sigma * N_u6 * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),rho_N * sigma * N_u6 * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c6 * iota_N,N_c6 * tau_N * (P_c6 / (P_c6 + P_u6)) * gamma,N_c6 * tau_N * (P_c2 / (P_c2 + P_u2)) * ((1 - gamma) / 5),N_c6 * tau_N * (P_c3 / (P_c3 + P_u3)) * ((1 - gamma) / 5),N_c6 * tau_N * (P_c4 / (P_c4 + P_u4)) * ((1 - gamma) / 5),N_c6 * tau_N * (P_c5 / (P_c5 + P_u5)) * ((1 - gamma) / 5),N_c6 * tau_N * (P_c1 / (P_c1 + P_u1)) * ((1 - gamma) / 5),rho_D * sigma * D_u * (P_c1 + P_c2 + P_c3 + P_c4 + P_c5 + P_c6 / (P_c1 + P_c2 + P_c3 + P_c4 + P_c5 + P_c6 + P_u1 + P_u2 + P_u3 + P_u4 + P_u5 + P_u6)),D_c * iota_D,D_c * tau_D * (P_c1 + P_c2 + P_c3 + P_c4 + P_c5 + P_c6 / (P_c1 + P_c2 + P_c3 + P_c4 + P_c5 + P_c6 + P_u1 + P_u2 + P_u3 + P_u4 + P_u5 + P_u6)),rho_N * psi * P_u1 * (N_c1 / (N_c1 + N_u1)) * gamma,rho_N * psi * P_u1 * (N_c2 / (N_c2 + N_u2)) * ((1 - gamma) / 5),rho_N * psi * P_u1 * (N_c3 / (N_c3 + N_u3)) * ((1 - gamma) / 5),rho_N * psi * P_u1 * (N_c4 / (N_c4 + N_u4)) * ((1 - gamma) / 5),rho_N * psi * P_u1 * (N_c5 / (N_c5 + N_u5)) * ((1 - gamma) / 5),rho_N * psi * P_u1 * (N_c6 / (N_c6 + N_u6)) * ((1 - gamma) / 5),rho_D * psi * P_u1 * (D_c / (D_c + D_u)),theta * P_u1 * (1-nu),theta * P_u1 * nu,rho_N * psi * P_u2 * (N_c2 / (N_c2 + N_u2)) * gamma,rho_N * psi * P_u2 * (N_c1 / (N_c1 + N_u1)) * ((1 - gamma) / 5),rho_N * psi * P_u2 * (N_c3 / (N_c3 + N_u3)) * ((1 - gamma) / 5),rho_N * psi * P_u2 * (N_c4 / (N_c4 + N_u4)) * ((1 - gamma) / 5),rho_N * psi * P_u2 * (N_c5 / (N_c5 + N_u5)) * ((1 - gamma) / 5),rho_N * psi * P_u2 * (N_c6 / (N_c6 + N_u6)) * ((1 - gamma) / 5),rho_D * psi * P_u2 * (D_c / (D_c + D_u)),theta * P_u2 * (1-nu),theta * P_u2 * nu,rho_N * psi * P_u3 * (N_c3 / (N_c3 + N_u3)) * gamma,rho_N * psi * P_u3 * (N_c2 / (N_c2 + N_u2)) * ((1 - gamma) / 5),rho_N * psi * P_u3 * (N_c1 / (N_c1 + N_u1)) * ((1 - gamma) / 5),rho_N * psi * P_u3 * (N_c4 / (N_c4 + N_u4)) * ((1 - gamma) / 5),rho_N * psi * P_u3 * (N_c5 / (N_c5 + N_u5)) * ((1 - gamma) / 5),rho_N * psi * P_u3 * (N_c6 / (N_c6 + N_u6)) * ((1 - gamma) / 5),rho_D * psi * P_u3 * (D_c / (D_c + D_u)),theta * P_u3 * (1-nu),theta * P_u3 * nu,rho_N * psi * P_u4 * (N_c4 / (N_c4 + N_u4)) * gamma,rho_N * psi * P_u4 * (N_c2 / (N_c2 + N_u2)) * ((1 - gamma) / 5),rho_N * psi * P_u4 * (N_c3 / (N_c3 + N_u3)) * ((1 - gamma) / 5),rho_N * psi * P_u4 * (N_c1 / (N_c1 + N_u1)) * ((1 - gamma) / 5),rho_N * psi * P_u4 * (N_c5 / (N_c5 + N_u5)) * ((1 - gamma) / 5),rho_N * psi * P_u4 * (N_c6 / (N_c6 + N_u6)) * ((1 - gamma) / 5),rho_D * psi * P_u4 * (D_c / (D_c + D_u)),theta * P_u4 * (1-nu),theta * P_u4 * nu,rho_N * psi * P_u5 * (N_c5 / (N_c5 + N_u5)) * gamma,rho_N * psi * P_u5 * (N_c2 / (N_c2 + N_u2)) * ((1 - gamma) / 5),rho_N * psi * P_u5 * (N_c3 / (N_c3 + N_u3)) * ((1 - gamma) / 5),rho_N * psi * P_u5 * (N_c4 / (N_c4 + N_u4)) * ((1 - gamma) / 5),rho_N * psi * P_u5 * (N_c1 / (N_c1 + N_u1)) * ((1 - gamma) / 5),rho_N * psi * P_u5 * (N_c6 / (N_c6 + N_u6)) * ((1 - gamma) / 5),rho_D * psi * P_u5 * (D_c / (D_c + D_u)),theta * P_u5 * (1-nu),theta * P_u5 * nu,rho_N * psi * P_u6 * (N_c6 / (N_c6 + N_u6)) * gamma,rho_N * psi * P_u6 * (N_c2 / (N_c2 + N_u2)) * ((1 - gamma) / 5),rho_N * psi * P_u6 * (N_c3 / (N_c3 + N_u3)) * ((1 - gamma) / 5),rho_N * psi * P_u6 * (N_c4 / (N_c4 + N_u4)) * ((1 - gamma) / 5),rho_N * psi * P_u6 * (N_c5 / (N_c5 + N_u5)) * ((1 - gamma) / 5),rho_N * psi * P_u6 * (N_c1 / (N_c1 + N_u1)) * ((1 - gamma) / 5),rho_D * psi * P_u6 * (D_c / (D_c + D_u)),theta * P_u6 * (1-nu),theta * P_u6 * nu,mu * P_c1,theta * P_c1 * nu,theta * P_c1 * (1-nu),mu * P_c2,theta * P_c2 * nu,theta * P_c2 * (1-nu),mu * P_c3,theta * P_c3 * nu,theta * P_c3 * (1-nu),mu * P_c4,theta * P_c4 * nu,theta * P_c4 * (1-nu),mu * P_c5,theta * P_c5 * nu,theta * P_c5 * (1-nu),mu * P_c6,theta * P_c6 * nu,theta * P_c6 * (1-nu)]
    end
    # a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
    x0 = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,0,3,0,3,0,3,0,3,0,3,0]
    # a `Matrix` of `Int64`, representing the transitions of the system, organised by row. Stoichiometric Matrix
    nu = [
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R1: N_u1 > N_c1
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R7: N_c1 > N_u1
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R14: N_u2 > N_c2
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R20: N_c2 > N_u2
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R27: N_u3 > N_c3
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R33: N_c3 > N_u3
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R40: N_u4 > N_c4
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R46: N_c4 > N_u4
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R53: N_u5 > N_c5
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R59: N_c5 > N_u5
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R66: N_u6 > N_c6
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R72: N_c6 > N_u6
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R79: D_u > D_c
    [0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R80: D_c > D_u
    [0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0]; #R82: P_u1 > P_c1 + Acquisition
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #R89: P_u1 > P_u1
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0]; #R90: P_u1 > P_c1
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0]; #R91: P_u2 > P_c2 + Acquisition
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0]; #R99: P_u2 > P_c2
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0]; #R100: P_u3 > P_c3 + Acquisition
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; #
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1];
    ]
    # a `Vector` of `Float64` representing the parameters of the system. #InitPar
    parms = [3.973,0.181,0.054,0.0464,0.1667,0.00949,0.0779,6.404,1.748,2.728,0.744,0.002083]
    tf = 10000.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

function CellDivision()
    function F_dd(x,parms)
        (TF,TFactive,mRNA,Protein) = x
        (kTFsyn,kTFdeg,kActivate,kInactivate,kX,kmRNAsyn,kmRNAdeg,kProteinsyn,kProteindeg) = parms
        [kTFsyn,kTFdeg*TF,kTFdeg*TFactive,kActivate*TF,kInactivate*TFactive,kmRNAsyn*(TFactive/(TFactive+kX)),kmRNAdeg*mRNA,kProteinsyn*mRNA,kProteindeg*Protein]
    end
    x0 = [2,10,10,220]
    nu = [[1 0 0 0];[-1 0 0 0];[0 -1 0 0];[-1 1 0 0];[1 -1 0 0];[0 0 1 0];[0 0 -1 0];[0 0 0 1];[0 0 0 -1]]
    parms = [200.0,20.0,2000.0,200.0,5.0,240.0,20.0,400.0,2.0]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

#Abstract Matrix issue
function BirthDeath()
    function F_dd(x,parms)
        (mRNA) = x
        (Ksyn,Kdeg) = parms
        [Ksyn*mRNA,Kdeg*mRNA]
    end
    x0 = [100]
    nu = [[1];
    [-1];]
    parms = [2.9,3.0]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

function BurstModel()
    function F_dd(x,parms)
        (ONstate,OFFstate,mRNA) = x
        (kon,koff,kdeg,ksyn) = parms
        [koff*ONstate,kon*OFFstate,ksyn*ONstate,kdeg*mRNA]
    end
    x0 = [0,1,0]
    nu = [[-1 1 0];
    [1 -1 0];
    [0 0 1];
    [0 0 -1];]
    parms = [0.05,0.05,2.5,80.0]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

function DecayingDimerizing()
    function F_dd(x,parms)
        (S1,S2,S3) = x
        (k1,k2,k3,k4) = parms
        [S1*k1,0.5*k2*S1*(S1-1),k3*S2,k4*S2]
    end
    x0 = [100000,0,0]
    nu = [[-1 0 0];
    [-2 1 0];
    [2 -1 0];
    [0 -1 1];]
    parms = [1.0,0.002,0.5,0.04]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

function GeneDuplication()
    function F_dd(x,parms)
        (G1,mRNA1,G2,mRNA2) = x
        (Ksyn,Kdeg) = parms
        [Ksyn*G1,Kdeg*mRNA1,Ksyn*G2,Kdeg*mRNA2]
    end
    x0 = [1,50,1,50]
    nu = [[0 1 0 0];
    [0 -1 0 0];
    [0 0 0 1];
    [0 0 0 -1];]
    parms = [10.0,0.2]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

#AbstractMatrix issue
function ImmigrationDeath()
    function F_dd(x,parms)
        (mRNA) = x
        (Ksyn,Kdeg) = parms
        [Ksyn,Kdeg*mRNA]
    end
    x0 = [50]
    nu = [[1];
    [-1];]
    parms = [10.0,0.2]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

#Issue
function Isomerization()
    function F_dd(x,parms)
        (X,Y) = x
        (k1) = parms
        [k1*X]
    end
    x0 = [20,0]
    nu = [[-1 1];]
    parms = [0.5]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))
end

#e.g. Polymerase(10.0, 1234)
function Polymerase(tf::Float64, seed::Int64)
    function F_dd(x,parms)
        (polymerase,mRNA) = x
        (Ksyn,Kdeg) = parms
        [Ksyn*polymerase,Kdeg*mRNA]
    end
    x0 = [10,0]
    nu = [[0 1];
    [0 -1];]
    parms = [0.5,0.1]
    seed!(seed)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))[:, Cols(:time, :x2)]
end

function Polymerase()
    function F_dd(x,parms)
        (polymerase,mRNA) = x
        (Ksyn,Kdeg) = parms
        [Ksyn*polymerase,Kdeg*mRNA]
    end
    x0 = [10,0]
    nu = [[0 1];
    [0 -1];]
    parms = [0.5,0.1]
    tf = 10.0
    seed!(1234)
    return ssa_data(ssa(x0,F_dd,nu,parms,tf))[:, Cols(:time, :x2)]
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