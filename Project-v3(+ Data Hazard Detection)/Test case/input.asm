# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
inc R1	       
push R1
inc R1
inc R2	        
inc R2         
inc R2         
pop R1
add r1,r2,r4
sub r4,r2,r5
swap r4,r5
not r5
