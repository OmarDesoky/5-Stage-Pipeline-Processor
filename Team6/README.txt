HOW TO RUN\TEST VHDL SRC CODE:
=============================

1- to load memory into the program, you first need to generate the instruction memory
by running the assemlber =>  "python Asm.py" NOTE: the input file must be name: input.asm

2- a generated file ram.mem is generated this file unfortunely doesn't run on modelsim directly
you have to copy the instruction starting from @0 ... till the end of instructions and paste it 
in test.mem file found in the base directory of project-v ( this happens because the format .mem 
for some reason is not recognised by modelsim, so we generated a .mem file and paste our code there
leaving "the first three // commented lines configurations)" ) 

3- last thing before running the .do file you need to change the base directory in line for example:
mem load -i {C:\Users\user\Desktop\5-Stage-Pipeline-Processor\Project-v2\test.mem} /processor/fetch/INS_Memory/ram

*here we change 'C:\Users\user\Desktop' to whatever location of the folder*

4- if you are trying to run an already generated mem file, you won't make step 2 and 
just change the base directory in the do file and leave the rest of the .do file
this is found in projectv1 and projectv2


5- if you face any difficulty running\testing project please inform us:
Mail : omar.ahmed98330@gmail.com

our github repo : https://github.com/OmarDesoky/5-Stage-Pipeline-Processor
