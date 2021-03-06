def mapOp(op):
    # two operands
    if op == "add":
        return "00100"
    elif op == "sub":
        return "00101"
    elif op == "and":
        return "00110"
    elif op == "or":
        return "00111"
    elif op == "swap":
        return "00011"
    elif op == "iadd":
        return "00010"        
    elif op == "shl":
        return "00000"
    elif op == "shr":
        return "00001"
    # memory
    elif op == "push":
        return "10000"
    elif op == "pop":
        return "10001"
    elif op == "ldm":
        return "10010"
    elif op == "ldd":
        return "10011"
    elif op == "std":
        return "10100"
    # jump
    elif op == "jz":
        return "11000"
    elif op == "jmp":
        return "11001"
    elif op == "call":
        return "11010"
    elif op == "ret":
        return "11110"
    elif op == "rti":
        return "11111"    
    # one operand
    elif op == "not":
        return "01000"
    elif op == "inc":
        return "01001"
    elif op == "dec":
        return "01010"
    elif op == "out":
        return "01011"
    elif op == "in":
        return "01100"
    # nop
    else:
        return "01111"


def mapReg(regName):
    if(regName == 'r0'):
        return "000"
    elif(regName == 'r1'):
        return "001"
    elif(regName == 'r2'):
        return "010"
    elif(regName == 'r3'):
        return "011"
    elif(regName == 'r4'):
        return "100"
    elif(regName == 'r5'):
        return "101"
    elif(regName == 'r6'):
        return "110"
    elif(regName == 'r7'):
        return "111"

# this function read input file
# it lowercases and removes newlines
# it outputs list of string lines
def readInput():
    f= open("input.asm","r")
    contents = f.read().splitlines()
    # convert to lowercase
    for i in range(len(contents)):
        contents[i] = contents[i].lower()
    # remove empty lines
    for line in contents:
        if line == '':
            contents.remove('')
    f.close()
    return contents

def hex2bin(hex, n_bits):
	n = int(hex, 16)
	out = bin(n).zfill(n_bits)
	b_indx = out.find('b')
	out = out[:b_indx] + "0" + out[b_indx+1:]
	return out[-n_bits:]


# this function handles takes a list of string lines
# it handles comments, tabs
# it outputs a list of list
# each list contain operation,register or value
# for example input (inc r1         #r1= 6, C --> 0, N -->0, Z-->0)
# output ['inc','r1']
def parseInstructions(contents):
    # remove comments
    for i in range(len(contents)):
        ind = contents[i].find("#")
        if(ind!=-1):
            contents[i] =contents[i][0:ind]

    # remove empty elements  => ''
    while("" in contents) : 
        contents.remove("")

    newContents = []
    for line in contents:
        newContents.append(list(line.split(" ")))

    contents = []
    for line in newContents:
        while("" in line) :
            line.remove("")
        contents.append(line)

    for i in  range(len(contents)):
        for j in range(len(contents[i])):
            contents[i][j] = contents[i][j].replace("\t","")

    newContents = []
    for i in range((len(contents))):
        line = " "
        newContents.append(line.join(contents[i]))

    # remove empty elements  => ''
    while("" in newContents) : 
        newContents.remove("")

    contents = []
    for line in newContents:
        contents.append(list(line.split(" ")))

    finalResult = []
    for i in range(len(contents)):
        oneInstruction = []
        oneInstruction.append(contents[i][0])

        if(len(contents[i])>1):
            words = " "
            oneInstruction += words.join(contents[i][1:]).split(',')

        finalResult.append(oneInstruction)

    for i in range(len(finalResult)):
        for j in range(len(finalResult[i])):
            finalResult[i][j] =finalResult[i][j].replace(" ","")


    return finalResult




# this function converts instructions into binary other than .org
def convertInstruction(listString):
    # 2 operands
    if(listString[0] == "add" or listString[0] == "sub" or 
    listString[0] == "and" or listString[0] == "or"):
        return convertAdd(listString)
    elif(listString[0] == "swap"):
        return convertSwap(listString)
    elif(listString[0] == "iadd"):
        return convertIadd(listString)
    elif(listString[0]== "shl" or listString[0]=="shr"):
        return convertSh(listString)
    # 1 operand
    elif(listString[0] == "nop"):
        return convertNop(listString)
    elif(listString[0] == "not" or listString[0] == "inc" or listString[0] == "dec" or listString[0] == "out" or listString[0] == "in"):
        return convertOneOp(listString)

    # mem
    elif(listString[0] == "push"):
        return convertPush(listString)
    elif(listString[0] == "pop"):
        return convertPop(listString)
    elif(listString[0] == "ldm"):
        return convertLdm(listString)
    elif(listString[0] == "ldd"):
        return convertLdd(listString)
    elif(listString[0] == "std"):
        return convertStd(listString)
    
    #jmp

    elif(listString[0] == "jz" or listString[0] == "jmp" or listString[0] == "call"):
        return convertJmp(listString)
    elif(listString[0] == "ret" or listString[0] == "rti"):
        return convertRt(listString)

def convertAdd(listString):
    return [mapOp(listString[0]) + mapReg(listString[3]) + mapReg(listString[1]) +mapReg(listString[2]) + "00"]

def convertSwap(listString):
    return [mapOp(listString[0]) + mapReg(listString[2]) + mapReg(listString[1]) +mapReg(listString[2]) + "00"]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def convertIadd(listString):
    return [mapOp(listString[0]) + mapReg(listString[2]) + mapReg(listString[1]) + "00000" , hex2bin(listString[3],16)]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def convertSh(listString):
    return [mapOp(listString[0]) + mapReg(listString[1]) + mapReg(listString[1]) + "00000" , hex2bin(listString[2],16)]

def convertNop(listString):
    return [mapOp(listString[0]) + "00000000000"]

def convertOneOp(listString):
    return [mapOp(listString[0]) + mapReg(listString[1]) + mapReg(listString[1]) + "00000"]

def convertPush(listString):
    return [mapOp(listString[0]) + "000" + mapReg(listString[1]) + "00000"]

def convertPop(listString):
    return [mapOp(listString[0]) + mapReg(listString[1]) + "00000000"]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def convertLdm(listString):
    return [mapOp(listString[0]) + mapReg(listString[1]) + "00000000" , hex2bin(listString[2],16)]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def convertLdd(listString):
    totalString = mapOp(listString[0]) + mapReg(listString[1]) + "0000" + hex2bin(listString[2],20)
    firstPart, secondPart = totalString[:int(len(totalString)/2)], totalString[int(len(totalString)/2):]
    return [firstPart,secondPart]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def convertStd(listString):
    totalString = mapOp(listString[0]) + "000" + mapReg(listString[1]) + "0" + hex2bin(listString[2],20)
    firstPart, secondPart = totalString[:int(len(totalString)/2)], totalString[int(len(totalString)/2):]
    return [firstPart,secondPart]

def convertJmp(listString):
    return [mapOp(listString[0]) + "000" + mapReg(listString[1]) + "00000"]

def convertRt(listString):
    return [mapOp(listString[0]) + "00000000000"]



contents = readInput()
parsedContent = parseInstructions(contents)

# output in ram
f= open("ram.mem","w")
f.write("// memory data file (do not edit the following line - required for mem load use)\r")
# f.write("// instance=/data_ram/ram\r")
f.write("// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1\r")

# add software solution for jmp/jz hazard. 
lastOp = '-1'
lastRdst1 = '-1'
lastRdst2 = '-1'
##########################################

i = 0
cursor = 0
while(i< len(parsedContent)):
    if(parsedContent[i][0] == ".org"):
        cursor = int(str(parsedContent[i][1]),16)
        # for numerical values; convert it to 32 bit
        if(parsedContent[i+1][0].isnumeric()):
            totalString = hex2bin(parsedContent[i+1][0],32)
            secondPart, firstPart = totalString[:int(len(totalString)/2)], totalString[int(len(totalString)/2):]
            f.write("@"+hex(cursor)[2:]+" "+ firstPart +"\r")
            cursor+=1
            f.write("@"+hex(cursor)[2:]+" "+ secondPart +"\r")
            cursor+=1
        else:
            for j in range(len(convertInstruction(parsedContent[i+1]))):
                IR = convertInstruction(parsedContent[i+1])[j]
                # check if there is a hazard and current instruction is jmp or jz => put stalls
                # we stall 2 NOPs unless its LDD or POP => 3 NOPs 
                if (j == 0) and (IR[8:11] == lastRdst1 or IR[8:11] == lastRdst2) and ( IR[0:5] == "11000" or IR[0:5] == "11001" ):
                    # insert 2 NOPs 
                    f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                    cursor+=1
                    f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                    cursor+=1
                    # if LDD or POP => another NOP
                    if lastOp == "10011" or lastOp == "10001":
                        f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                        cursor+=1

                if j == 0:
                    # swap instruction
                    # NOP, OUT, PUSH, STD, ANY JMP => we should not save last IR
                    if IR[0:5] == "01111" or IR[0:5] == "01011" or IR[0:5] == "10000" or IR[0:5] == "10100" or IR[0:2] == "11":
                        lastOp = '-1'
                        lastRdst1 = '-1'
                        lastRdst2 = '-1'

                    elif IR[0:5] == "00011":
                        lastOp = IR[0:5]
                        lastRdst1 = IR[5:8]
                        lastRdst2 = IR[8:11]
                    else:
                        lastOp = IR[0:5]
                        lastRdst1 = IR[5:8]
                        lastRdst2 = '-1'

                f.write("@"+hex(cursor)[2:]+" "+ IR +"\r")
                cursor+=1
        i+=2
    else:
        for j in range(len(convertInstruction(parsedContent[i]))):
            IR = convertInstruction(parsedContent[i])[j]
            # check if there is a hazard and current instruction is jmp or jz => put stalls
            # we stall 2 NOPs unless its LDD or POP => 3 NOPs 
            if (j == 0) and (IR[8:11] == lastRdst1 or IR[8:11] == lastRdst2) and ( IR[0:5] == "11000" or IR[0:5] == "11001" ):
                # insert 2 NOPs 
                f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                cursor+=1
                f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                cursor+=1

                if lastOp == "10011" or lastOp == "10001":
                    f.write("@"+hex(cursor)[2:]+" "+ "0111100000000000" +"\r")
                    cursor+=1
                    
            if j == 0:
                # swap instruction
                # NOP, OUT, PUSH, STD, ANY JMP => we should not save last IR
                if IR[0:5] == "01111" or IR[0:5] == "01011" or IR[0:5] == "10000" or IR[0:5] == "10100" or IR[0:2] == "11":
                    lastOp = '-1'
                    lastRdst1 = '-1'
                    lastRdst2 = '-1'

                elif IR[0:5] == "00011":
                    lastOp = IR[0:5]
                    lastRdst1 = IR[5:8]
                    lastRdst2 = IR[8:11]
                else:
                    lastOp = IR[0:5]
                    lastRdst1 = IR[5:8]
                    lastRdst2 = '-1'

            f.write("@"+hex(cursor)[2:]+" "+ IR +"\r")
            cursor+=1   
        i+=1
f.close()
