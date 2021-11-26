package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"os"
)

type patch struct {
	Offset        int    `json:"offset"`
	PatchDataFile string `json:"patchDataFile"`
	Description   string `json:"description"`
}

type patchConfig struct {
	Patches []patch `json:"patches"`
}

const ()

func main() {
	// param: input kid icarus file
	inputFile := flag.String("in", "Kid Icarus (UE).nes", "The vanilla Kid Icarus ROM to patch")
	// param: output patched file
	outputFile := flag.String("out", "Kid Icarus (patched).nes", "The output of the patched rom")

	// param offset to place new autogenlvl1.bin code, used as parameter so we can
	// generate the proper jump in replace_routine
	autogenOffset := flag.Int("autoGenOffset", 0x01BE10, "the offset of where the autogenlvl bytes will be patched onto")
	autogenJumpLocation := flag.Int("jumpLoc", 0xBED2, "the offset to jump to the new autogenlvl sub routine")
	autoGenDungeonOffset := flag.Int("autoGenDungeonOffset", 0x11510, "the offset where the fortress_gen bytes will be patched onto")
	dungeonRoutineJumpLocation := flag.Int("dungeonJumpLoc", 0x1510 + 164 - 0x10, "where to jump for the dungeon generation routine") 
	flag.Parse()

	fmt.Printf("\tData Patch Start Address %06X\n\tNew Subroutine Address %04X\n", *autogenOffset, *autogenJumpLocation)
	var jumpBytes []byte
	jumpBytes = append(jumpBytes, 0x20)
	jumpBytes = append(jumpBytes, byte(*autogenJumpLocation&0x0000FF))
	jumpBytes = append(jumpBytes, byte((*autogenJumpLocation&0x00FF00)>>8))
	jumpBytes = append(jumpBytes, 0x60)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0xEA)
	jumpBytes = append(jumpBytes, 0x20)
	jumpBytes = append(jumpBytes, byte(*dungeonRoutineJumpLocation&0x0000FF))
	jumpBytes = append(jumpBytes, byte((*dungeonRoutineJumpLocation&0x00FF00)>>8))
	jumpBytes = append(jumpBytes, 0x60)
	fmt.Println(fmt.Sprintf("Jump Bytes: %x\n", jumpBytes))

	autoGenBytes, err := ioutil.ReadFile("autogenlvl1.bin")
	if err != nil {
		fmt.Printf("Error reading in autogen patch: %s", err)
		return
	}

	dungeonGenBytes, err := ioutil.ReadFile("fortress_gen.bin")
	if err != nil {
		fmt.Printf("Error reading in dungeon generation patch: %s", err)
		return
	}
	
	enemyPositionBytes, err := ioutil.ReadFile("enemy_position.bin")
	if err != nil {
		fmt.Printf("Error reading in enemy position patch: %s", err)
		return
	}
	
	doorPatchBytes, err := ioutil.ReadFile("end_of_level_upgrade_doors.bin")
	if err != nil {
		fmt.Printf("Error reading in door patch: %s", err)
		return
	}
	
	removeUpgradeReqBytes, err := ioutil.ReadFile("remove_upgrade_score_req.bin")
	if err != nil {
		fmt.Printf("Error reading in upgrade requirements patch: %s", err)
		return
	} 
	
	adjustPricesBytes, err := ioutil.ReadFile("price_change.bin")
	if err != nil {
		fmt.Printf("Error reading in price change patch: %s", err)
		return
	}

	if _, err := copyFile(*inputFile, *outputFile); err != nil {
		fmt.Printf("Error copying inpute file to output file: %s", err)
		return
	}

	patchFile(*outputFile, 0x0198F2, jumpBytes)
	patchFile(*outputFile, *autogenOffset, autoGenBytes)
	patchFile(*outputFile, *autoGenDungeonOffset, dungeonGenBytes)
	patchFile(*outputFile, 0x1B278, enemyPositionBytes)
	patchFile(*outputFile, 0x1B56C, enemyPositionBytes)
	patchFile(*outputFile, 0x1B840, enemyPositionBytes)
	patchFile(*outputFile, 0x18ABE, removeUpgradeReqBytes)
	patchFile(*outputFile, 0x1EFB2, adjustPricesBytes)
	
	patchFile(*outputFile, 0x1F190, doorPatchBytes)
	// patchFile(*outputFile, 0x1EFD9, doorPatchBytes)
	
	// These 2 patches replace the "score" value in the pause screen with displaying our current seed
	patchFile(*outputFile, 0x1E74E, []byte{0xB0, 0x00})
	patchFile(*outputFile, 0x1E791, []byte{0x28, 0x1A, 0x1A, 0x19, 0x0F})
	
	// These 3 patches invert the map/pencil/torch functionality
	patchFile(*outputFile, 0x1E27B, []byte{0xD0})
	patchFile(*outputFile, 0x1524C, []byte{0xD0})
	patchFile(*outputFile, 0x1E21B, []byte{0xD0})
	
	// Patch out all the centurions
	patchFile(*outputFile, 0x1B2C4, createDuplicateValueSlice(0xFF, 58))
	patchFile(*outputFile, 0x1B5B8, createDuplicateValueSlice(0xFF, 66))
	patchFile(*outputFile, 0x1B88C, createDuplicateValueSlice(0xFF, 40))

	// patch out all the moving platforms
	patchFile(*outputFile, 0x1A4B0, createDuplicateValueSlice(0xFF, 0x80))
	patchFile(*outputFile, 0x1AE3B, createDuplicateValueSlice(0xFF, 0x80))
	
	// change how we load doors to read from a space that we can write to
	patchFile(*outputFile, 0x8066, []byte{0x00, 0x61})

}

func createDuplicateValueSlice(value byte, repeatedNum int) []byte {
	var result []byte
	for i := 0; i < repeatedNum; i++ {
		result = append(result, value)
	}
	return result
}
func copyFile(src string, dst string) (int64, error) {
	sourceFileStat, err := os.Stat(src)
	if err != nil {
		return 0, err
	}

	if !sourceFileStat.Mode().IsRegular() {
		return 0, fmt.Errorf("%s is not a regular file", src)
	}

	source, err := os.Open(src)
	if err != nil {
		return 0, err
	}
	defer source.Close()

	destination, err := os.Create(dst)
	if err != nil {
		return 0, err
	}
	defer destination.Close()
	nBytes, err := io.Copy(destination, source)
	return nBytes, err
}

func patchFile(outputFile string, offset int, patchBytes []byte) error {
	file, err := os.OpenFile(outputFile, os.O_RDWR, 0644)
	if err != nil {
		return err
	}

	defer file.Close()

	len, err := file.WriteAt(patchBytes, int64(offset))
	if err != nil {
		return err
	}

	fmt.Printf("\nLength: %d bytes at %x", len, offset)
	fmt.Printf("\nFile Name: %s", file.Name())
	return nil
}

// This is specific to kid icarus, which is MMC1, which usually works like this.
// if something ever doesn't work and we're jumping to the wrong spot this is probably why
func convertPCRomAddrToCPUAddress(pcRomAddress int) int {
	// should convert something like 0x01BEE2 -> 0xBED2
	return (pcRomAddress - 0x10) & 0xFFFF
}

func converCPUAddressToRomAddr(cpuAddress int, page int) int {
	// $BE00 -> 1BE10
	return (0x10000 * page) + 10 + cpuAddress
}
