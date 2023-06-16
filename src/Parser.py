import sys
import pysces
import numpy as np

#python3 Parser.py DecayingDimerizing.psc

#name = sys.argv[1]
#name = "DecayingDimerizing"

# a `Vector` of `Int64`, representing the initial states of the system. i.e. states of S1, S2, S3. #InitVar
def get_initvar(model):
    output = "x0 = ["

    for i in model.species:
        output += (str(int(getattr(model, i))) + ",")

    output = output[0:-1] + "]\n"
    return output

def get_initparam(model):
    output = "parms = ["

    for i in model.parameters:
        output += (str(getattr(model, i)) + ",")

    output = output[0:-1] + "]\n"
    return output

def get_matrix(model):
    output = "nu = [["
    m = np.asarray(np.transpose(model.Nmatrix.array), dtype='int')
    for i in m:# removes "".psc" if in string

        for j in i:
            output += str(j) + " "
        output = output[0:-1] + "];["
    output = output[0:-2] + "]\n"
    return output

def get_propensities(model):
    reactions = model.reactions
    output = "["
    current_reaction = 0

    f = open(model.ModelDir + "/" + model.ModelFile, "r")

    for x in f:
        if reactions[current_reaction] in x:
            current_reaction += 1
            f.readline()
            output += str(f.readline().split())[2:-2] + ","
            if current_reaction >= len(reactions):
                break
    f.close()
    return output[0:-1] + "]\n"

def get_F_dd(model):
    funcString = "function F_dd(x,parms)\n"
    stateString = "    ("
    paramString = "    ("
    popString = "    " + get_propensities(model)

    for i in model.species:
        stateString += str(i) + ","
    stateString = stateString[0:-1] + ") = x\n"

    for i in model.parameters:
        paramString += str(i) + ","
    paramString = paramString[0:-1] + ") = parms\n"

    return(funcString + stateString + paramString + popString + "end\n")

def write_file(name):

    if (name.find(".psc") != -1):
        name = name[0:name.find(".psc")]

    model = pysces.model(name + ".psc", dir='c:\\Pysces\\psc') #create pysces model
    output = "using Gillespie\nimport Random: seed!\n" + get_F_dd(model) + get_initvar(model) + get_matrix(model) + get_initparam(model) + "tf = 10.0\nseed!(1234)\nresult = ssa(x0,F_dd,nu,parms,tf)"
    f = open(name + ".jl", "w") #Create new Julia file
    f.write(output)
    f.close
    
write_file("DecayingDimerizing")