# define out start location for the new data, this is the only
# variable piece of information
# this is the rom address
offsetROM=0x1BA00
#offsetROM_DUNG=0x1BD00
offsetROM_DUNG=0x1F2A0

# convert rom address to cpu address
offsetCPU=$((($offsetROM - 0x10) & 0xFFFF))
offsetCPUD=$((($offsetROM_DUNG - 0x10) & 0xFFFF))
dungeonRooms=42

offsetStr=$(printf '%X\n' $offsetCPU)
echo "Offset: $offsetStr"
offsetDStr=$(printf '%X\n' $offsetCPUD)
echo "Dungeon Offset: $offsetDStr"

# build the asm
 ./asm6f_64.exe fortress_gen.asm

 ./asm6f_64.exe w1hijack.asm
 ./asm6f_64.exe w2hijack.asm
 ./asm6f_64.exe w3hijack.asm
 ./asm6f_64.exe w4hijack.asm

 ./asm6f_64.exe enemyFrequencyTable.asm
 ./asm6f_64.exe lvlRandomizer.asm
 ./asm6f_64.exe w4Randomizer.asm

 ./asm6f_64.exe w1screendata.asm
 ./asm6f_64.exe w2screendata.asm
 ./asm6f_64.exe w3screendata.asm

 ./asm6f_64.exe w1itemLocations.asm
 ./asm6f_64.exe w2itemLocations.asm
 ./asm6f_64.exe w3itemLocations.asm

 ./asm6f_64.exe doorDistribution.asm 
 ./asm6f_64.exe platformData.asm

 ./asm6f_64.exe setSeedFromPassword.asm
 ./asm6f_64.exe passwordHijack.asm

# call the applypatch.go with the start location
dungJumpLoc=$(($offsetCPUD + ($dungeonRooms * 4)))
go run applypatch.go --autoGenOffset=$offsetROM --jumpLoc=$offsetCPU --autoGenDungeonOffset=$offsetROM_DUNG --dungeonJumpLoc=$dungJumpLoc

# success