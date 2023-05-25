# read file contents, one line at a time and concatenate to buffer

buffer = IOBuffer()

open("Gamma.psc") do f
 
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

print(String(take!(buffer)))