# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
#setC           #C --> 1
NOP            #No change
#ClRC           #C --> 0
NOT R1         #R1 =FFFFFFFF , C--> no change, N --> 1, Z --> 0
inc R1	       #R1 =00000000 , C --> 1 , N --> 0 , Z --> 1
in R1	       #R1= 5,add 5 on the in port,flags no change	
in R2          #R2= 10,add 10 on the in port, flags no change
NOT R2	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
inc R1         #R1= 6, C --> 0, N -->0, Z-->0
Dec R2         #R2= FFEE,C-->1 , N-->1, Z-->0
add r1,r2,r3
sub r2,r3, r7
not r5
and r3,r4,r5
out R1
out R2
ldm R2,100
ldd r2,100
std r1,50
shr r5,100