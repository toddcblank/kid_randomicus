# define out start location for the new data, this is the only
# variable piece of information
# this is the rom address
offsetROM=0x1BA00
#offsetROM_DUNG=0x1BD00
offsetROM_DUNG=0x1F300

# convert rom address to cpu address
offsetCPU=$((($offsetROM - 0x10) & 0xFFFF))
offsetCPUD=$((($offsetROM_DUNG - 0x10) & 0xFFFF))
dungeonRooms=42

offsetStr=$(printf '%X\n' $offsetCPU)
echo "Offset: $offsetStr"
offsetDStr=$(printf '%X\n' $offsetCPUD)
echo "Dungeon Offset: $offsetDStr"
# replace the current offset in the autogenlvl1.asm with this value
# sed -i "s/ROOM_RULES_DATA\(\s*\)equ\(\s*\)\$[0-9A-F]*/ROOM_RULES_DATA\1equ\2\$$offsetStr/1" autogenlvl1.asm
#ruleDataLines=$(grep "^db \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F]$" autogenlvl1.asm |wc -l)
#ruleDataLenDec=$((4 * $ruleDataLines))
#ruleDataLen=$(printf '%x\n' $ruleDataLenDec)
#echo $ruleDataLen
#
#roomAddrLines=$(grep "^db \$[0-9A-F][0-9A-F], \$[0-9A-F][0-9A-F]$" autogenlvl1.asm |wc -l)
#roomAddrLenDec=$((2 * $roomAddrLines))
#roomAddrLen=$(printf '%x\n' $roomAddrLenDec)
#echo $roomAddrLen
#
#doorDataLines=$(grep "^db \$[0-9A-F][0-9A-F]$" autogenlvl1.asm |wc -l)
#doorDataLenDec=$((1 * $doorDataLines))
#doorDataLen=$(printf '%x\n' $doorDataLenDec)
#echo $doorDataLen


#sed -i "s/ROOM_ADDRESSES\(\s*\)equ\(\s*\)ROOM_RULES_DATA + [^;]*;/ROOM_ADDRESSES\1equ\2ROOM_RULES_DATA + $ruleDataLenDec;/1" autogenlvl1.asm

# build the asm
 ./asm6f_64.exe autogenlvl1.asm
 ./asm6f_64.exe horizontalScreenData.asm
 ./asm6f_64.exe fortress_gen.asm
 ./asm6f_64.exe lvl2-data.asm
 ./asm6f_64.exe lvl2gen.asm
 ./asm6f_64.exe w2enemyTables.asm
 
# call the applypatch.go with the start location
dungJumpLoc=$(($offsetCPUD + ($dungeonRooms * 4)))
go run applypatch.go --autoGenOffset=$offsetROM --jumpLoc=$offsetCPU --autoGenDungeonOffset=$offsetROM_DUNG --dungeonJumpLoc=$dungJumpLoc

# success