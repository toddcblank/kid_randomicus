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

# build the asm
 ./asm6f_64.exe autogenlvl1.asm
 ./asm6f_64.exe horizontalScreenData.asm
 ./asm6f_64.exe fortress_gen.asm
 ./asm6f_64.exe lvl2-data.asm
 ./asm6f_64.exe lvl2gen.asm
 ./asm6f_64.exe w2enemyTables.asm
 ./asm6f_64.exe lvl2ItemData.asm
 
# call the applypatch.go with the start location
dungJumpLoc=$(($offsetCPUD + ($dungeonRooms * 4)))
go run applypatch.go --autoGenOffset=$offsetROM --jumpLoc=$offsetCPU --autoGenDungeonOffset=$offsetROM_DUNG --dungeonJumpLoc=$dungJumpLoc

# success