# define out start location for the new data, this is the only
# variable piece of information
# this is the rom address
offsetROM=0x1BA00

# convert rom address to cpu address
offsetCPU=$((($offsetROM - 0x10) & 0xFFFF))

offsetStr=$(printf '%X\n' $offsetCPU)
echo $offsetStr
# replace the current offset in the autogenlvl1.asm with this value
sed -i "s/ROOM_RULES_DATA\(\s*\)equ\(\s*\)\$[0-9A-F]*/ROOM_RULES_DATA\1equ\2\$$offsetStr/1" autogenlvl1.asm
ruleDataLines=$(grep "db \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F]$" autogenlvl1.asm |wc -l)
ruleDataLenDec=$((4 * $ruleDataLines))
ruleDataLen=$(printf '%x\n' $ruleDataLenDec)
echo $ruleDataLen

roomAddrLines=$(grep "db \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F]$" autogenlvl1.asm |wc -l)
roomAddrLenDec=$((2 * $roomAddrLines))
roomAddrLen=$(printf '%x\n' $roomAddrLenDec)
echo $roomAddrLen

sed -i "s/ROOM_ADDRESSES\(\s*\)equ\(\s*\)ROOM_RULES_DATA + [^;]*;/ROOM_ADDRESSES\1equ\2ROOM_RULES_DATA + $ruleDataLenDec;/1" autogenlvl1.asm

# build the asm
 ./asm6f_64.exe autogenlvl1.asm

# call the applypatch.go with the start location
jumpLoc=$(($offsetCPU + $ruleDataLenDec + $roomAddrLenDec))
go run applypatch.go --autoGenOffset=$offsetROM --jumpLoc=$jumpLoc

# success