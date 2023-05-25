#Looks for file_name in pysces_models folder and returns a string with the file's contents
function getModelString(file_name)
    buffer = IOBuffer()

    open(pwd() * "/pysces_models/" * file_name) do f
    
        # line_number
        line = 0  
    
        # read till end of file
        while ! eof(f) 
    
        # read a new / next line for every iteration          
        s = readline(f)         
        line += 1
        println(buffer, "$line . $s")
        end
    
    end

    return String(take!(buffer))

end

BirthDeath = getModelString("BirthDeath.psc")
print(BirthDeath)