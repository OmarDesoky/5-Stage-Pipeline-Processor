# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
inc R1	       #R1 =00000000 , C --> 1 , N --> 0 , Z --> 1
inc R1
inc R2	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
inc R2         #R1= 6, C --> 0, N -->0, Z-->0
inc R2         #R2= FFEE,C-->1 , N-->1, Z-->0
add r1,r2,r4
sub r4,r2,r5
swap r4,r5
not r5
