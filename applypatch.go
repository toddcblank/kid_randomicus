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

var patchInformation [][]int

func main() {

	patchInformation = make([][]int, 0, 0)

	// param: input kid icarus file
	inputFile := flag.String("in", "Kid Icarus (UE).nes", "The vanilla Kid Icarus ROM to patch")
	// param: output patched file
	outputFile := flag.String("out", "Kid Icarus (patched).nes", "The output of the patched rom")

	// param offset to place new autogenlvl1.bin code, used as parameter so we can
	// generate the proper jump in replace_routine
	autogenOffset := flag.Int("autoGenOffset", 0x01BE10, "the offset of where the autogenlvl bytes will be patched onto")
	autogenJumpLocation := flag.Int("jumpLoc", 0xBED2, "the offset to jump to the new autogenlvl sub routine")
	autoGenDungeonOffset := flag.Int("autoGenDungeonOffset", 0x11510, "the offset where the fortress_gen bytes will be patched onto")
	dungeonRoutineJumpLocation := flag.Int("dungeonJumpLoc", 0x1510+164-0x10, "where to jump for the dungeon generation routine")
	flag.Parse()

	fmt.Printf("\tData Patch Start Address %06X\n\tNew Subroutine Address %04X\n", *autogenOffset, *autogenJumpLocation)
	var fortressHijackBytes []byte
	fortressHijackBytes = append(fortressHijackBytes, 0x20)
	fortressHijackBytes = append(fortressHijackBytes, byte(*dungeonRoutineJumpLocation&0x0000FF))
	fortressHijackBytes = append(fortressHijackBytes, byte((*dungeonRoutineJumpLocation&0x00FF00)>>8))
	fortressHijackBytes = append(fortressHijackBytes, 0x60)
	fortressHijackBytes = append(fortressHijackBytes, createDuplicateValueSlice(0xEA, 11)...)
	fmt.Println(fmt.Sprintf("Jump Bytes: %x\n", fortressHijackBytes))

	// autoGenBytes, err := ioutil.ReadFile("autogenlvl1.bin")
	//if err != nil {
	//	fmt.Printf("Error reading in autogen patch: %s", err)
	//	return
	//}

	// horizontalScreenDataBytes, err := ioutil.ReadFile("horizontalScreenData.bin")
	//if err != nil {
	//	fmt.Printf("Error reading in horizontal scrolling level data: %s", err)
	//	return
	//}

	w1HijackBytes, err := ioutil.ReadFile("w1hijack.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 1 hijack patch: %s", err)
		return
	}

	w1ScreenData, err := ioutil.ReadFile("w1screendata.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 1 hijack patch: %s", err)
		return
	}

	w1ItemData, err := ioutil.ReadFile("w1itemLocations.bin")
	if err != nil {
		fmt.Printf("Errof reading in lvl 1 item locations: %s", err)
		return
	}

	w3HijackBytes, err := ioutil.ReadFile("w3hijack.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 3 hijack patch: %s", err)
		return
	}

	w3ScreenData, err := ioutil.ReadFile("w3screendata.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 3 hijack patch: %s", err)
		return
	}

	w3ItemData, err := ioutil.ReadFile("w3itemLocations.bin")
	if err != nil {
		fmt.Printf("Errof reading in lvl 3 item locations: %s", err)
		return
	}

	doorDistributionBytes, err := ioutil.ReadFile("doorDistribution.bin")
	if err != nil {
		fmt.Printf("Errof reading in lvl 3 item locations: %s", err)
		return
	}

	platformDataBytes, err := ioutil.ReadFile("platformData.bin")
	if err != nil {
		fmt.Printf("error reading in platform data bytes: %s", err)
	}

	w4Randomizer, err := ioutil.ReadFile("w4randomizer.bin")
	if err != nil {
		fmt.Printf("Errof reading in lvl 4 randomizer: %s", err)
		return
	}
	w4HijackBytes, err := ioutil.ReadFile("w4hijack.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 4 hijack patch: %s", err)
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

	lvl2HijackBytes, err := ioutil.ReadFile("w2hijack.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 2 hijack patch: %s", err)
		return
	}

	lvl2ScreenData, err := ioutil.ReadFile("w2screendata.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 2 data: %s", err)
		return
	}

	lvlRandomizer, err := ioutil.ReadFile("lvlRandomizer.bin")
	if err != nil {
		fmt.Printf("Error reading in lvl 2 randomizer patch: %s", err)
		return
	}

	enemyFrequencyTable, err := ioutil.ReadFile("enemyFrequencyTable.bin")
	if err != nil {
		fmt.Printf("Error reading in world 2 enemey tables: %s", err)
		return
	}

	lvl2ItemData, err := ioutil.ReadFile("w2ItemLocations.bin")
	if err != nil {
		fmt.Printf("Error reading in world 2 item data: %s", err)
		return
	}

	if _, err := copyFile(*inputFile, *outputFile); err != nil {
		fmt.Printf("Error copying inpute file to output file: %s", err)
		return
	}

	titleTextAlphabet, err := ioutil.ReadFile("title-screen-alphabet.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	titleText1, err := ioutil.ReadFile("title-text-line1.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	titleText2, err := ioutil.ReadFile("title-text-line2.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	titleText3, err := ioutil.ReadFile("title-text-line3.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	titleText4, err := ioutil.ReadFile("title-text-line4.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	endingText1, err := ioutil.ReadFile("ending-text-line1.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}
	endingText2, err := ioutil.ReadFile("ending-text-line2.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}
	endingTextUrl, err := ioutil.ReadFile("ending-text-url.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}
	endingTextSlash, err := ioutil.ReadFile("ending-text-slash.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}
	passwordText, err := ioutil.ReadFile("passwordScreenTxt.bin")
	if err != nil {
		fmt.Printf("error reading patch: %s", err)
		return
	}

	passwordHijack, err := ioutil.ReadFile("passwordHijack.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}
	setSeedFromPassword, err := ioutil.ReadFile("setSeedFromPassword.bin")
	if err != nil {
		fmt.Printf("Error reading patch: %s", err)
		return
	}

	patchFile(*outputFile, 0x6BE0, passwordHijack)
	patchFile(*outputFile, 0x6F10, setSeedFromPassword)

	patchFile(*outputFile, 0x9752, w1HijackBytes)
	patchFile(*outputFile, 0x1FA20, w1ScreenData)
	patchFile(*outputFile, 0x1FE40, w1ItemData)

	patchFile(*outputFile, 0xAE37, lvl2HijackBytes)
	patchFile(*outputFile, 0x1F140, lvl2ScreenData)
	patchFile(*outputFile, 0x1FE10, lvl2ItemData)

	patchFile(*outputFile, 0xD9E9, w3HijackBytes)
	patchFile(*outputFile, 0x1FB80, w3ScreenData)
	patchFile(*outputFile, 0x1FE70, w3ItemData)

	patchFile(*outputFile, 0x1FDE0, doorDistributionBytes)
	patchFile(*outputFile, 0x1F9B0, platformDataBytes)

	patchFile(*outputFile, 0xF87E, w4HijackBytes)
	patchFile(*outputFile, 0x1FE90, w4Randomizer)

	// Fortresses
	patchFile(*outputFile, 0x1991F, fortressHijackBytes)
	patchFile(*outputFile, *autoGenDungeonOffset, dungeonGenBytes)
	patchFile(*outputFile, 0x1B278, enemyPositionBytes)
	patchFile(*outputFile, 0x1B56C, enemyPositionBytes)
	patchFile(*outputFile, 0x1B840, enemyPositionBytes)

	patchFile(*outputFile, 0x18ABE, removeUpgradeReqBytes)
	patchFile(*outputFile, 0x1EFB2, adjustPricesBytes)
	patchFile(*outputFile, 0x1F670, lvlRandomizer)
	patchFile(*outputFile, 0x1FD10, enemyFrequencyTable)

	// These 2 patches replace the "score" value in the pause screen with displaying our current seed
	patchFile(*outputFile, 0x1E74E, []byte{0xB0, 0x00})
	patchFile(*outputFile, 0x1E791, []byte{0x28, 0x1A, 0x1A, 0x19, 0x0F})

	// These 3 patches invert the map/pencil/torch functionality
	patchFile(*outputFile, 0x1E27B, []byte{0xD0})
	patchFile(*outputFile, 0x1524C, []byte{0xD0})
	patchFile(*outputFile, 0x1E21B, []byte{0xD0})

	// fun hammer damage =D
	patchFile(*outputFile, 0x16B4E, []byte{0x19})
	patchFile(*outputFile, 0x171C1, []byte{0x19})
	patchFile(*outputFile, 0x179F7, []byte{0x19})

	// Change where we read the boss music index so that it's in RAM that we can write to
	patchFile(*outputFile, 0x1CB8E, []byte{0xD0, 0x00})

	// Patch out all the centurions
	patchFile(*outputFile, 0x1B2C4, createDuplicateValueSlice(0xFF, 58))
	patchFile(*outputFile, 0x1B5B8, createDuplicateValueSlice(0xFF, 66))
	patchFile(*outputFile, 0x1B88C, createDuplicateValueSlice(0xFF, 40))

	// patch out all the moving platforms
	patchFile(*outputFile, 0x1A4B0, createDuplicateValueSlice(0xFF, 0x80))
	patchFile(*outputFile, 0x1AE3B, createDuplicateValueSlice(0xFF, 0x80))
	patchFile(*outputFile, 0xBDC3, createDuplicateValueSlice(0xFF, 0x80))

	// change where we read moving platform data from
	// The radomizer writes all the platform data for all levels starting at 6300
	patchFile(*outputFile, 0x8B62, []byte{0x00, 0x63})
	patchFile(*outputFile, 0x8B71, []byte{0x01, 0x63})
	patchFile(*outputFile, 0x8B78, []byte{0x02, 0x63})

	// W2
	patchFile(*outputFile, 0xA971, []byte{0x00, 0x63})
	patchFile(*outputFile, 0xA980, []byte{0x01, 0x63})
	patchFile(*outputFile, 0xA987, []byte{0x02, 0x63})

	patchFile(*outputFile, 0xCDFD, []byte{0x00, 0x63})
	patchFile(*outputFile, 0xCE0C, []byte{0x01, 0x63})
	patchFile(*outputFile, 0xCE13, []byte{0x02, 0x63})

	// change where we load enemies for W1
	patchFile(*outputFile, 0x1A620, []byte{0x80, 0x61, 0x80, 0x61, 0x80, 0x61})
	patchFile(*outputFile, 0x1A68A, []byte{0xA0, 0x61, 0xA0, 0x61, 0xA0, 0x61})
	// for T2/T4 we change the pointers to point to the beginning of the 0x00 data
	// this prevents platforms from ever being messed with by positional data if the
	// levels are longer than the original ones
	patchFile(*outputFile, 0x1A657, []byte{0x0B, 0x7D, 0x0B, 0x7D})
	patchFile(*outputFile, 0x1A6BF, []byte{0x75, 0x7D, 0x75, 0x7D, 0x75, 0x7D})

	// set all the positions for T3 to be 38, which puts enemies toward the bottom in the middle
	patchFile(*outputFile, 0x1A6C5, createDuplicateValueSlice(0x38, 0x1B))

	// zero out positional info for enemies in W and W3, leaving it there breaks some platforms
	// we dont' have to do it for W2 as it's already all 0x00
	patchFile(*outputFile, 0x1A65B, createDuplicateValueSlice(0x00, 47))
	patchFile(*outputFile, 0x1B035, createDuplicateValueSlice(0x00, 52))

	// change where we load enemies for W2
	patchFile(*outputFile, 0xBC4F, []byte{0x80, 0x61, 0x80, 0x61, 0x80, 0x61})
	patchFile(*outputFile, 0xBD09, []byte{0xA0, 0x61, 0xA0, 0x61, 0xA0, 0x61})
	// for T2/T4 we change the pointers to point to the beginning of the 0x00 data
	// this prevents platforms from ever being messed with by positional data if the
	// levels are longer than the original ones
	patchFile(*outputFile, 0xBCAE, []byte{0xA2, 0xBC, 0xA2, 0xBC})
	patchFile(*outputFile, 0xBD68, []byte{0xA2, 0xBC, 0xA2, 0xBC})

	// change where we load enemies for W3
	patchFile(*outputFile, 0x1AF81, []byte{0x80, 0x61, 0x80, 0x61, 0x80, 0x61})
	patchFile(*outputFile, 0x1AFF5, []byte{0xA0, 0x61, 0xA0, 0x61, 0xA0, 0x61})
	// for T2/T4 we change the pointers to point to the beginning of the 0x00 data
	// this prevents platforms from ever being messed with by positional data if the
	// levels are longer than the original ones
	patchFile(*outputFile, 0x1AFBD, []byte{0x21, 0x78, 0x21, 0x78})
	patchFile(*outputFile, 0x1B031, []byte{0xA2, 0xBC, 0xA2, 0xBC})

	// change where we load enemies for W4
	patchFile(*outputFile, 0xFF07, []byte{0x80, 0x61, 0x80, 0x61, 0x80, 0x61})
	patchFile(*outputFile, 0xFF1C, []byte{0xA0, 0x61, 0xA0, 0x61, 0xA0, 0x61})

	// change how we load doors to read from a space that we can write to
	patchFile(*outputFile, 0x8066, []byte{0x00, 0x61})
	patchFile(*outputFile, 0xC066, []byte{0x00, 0x61})
	patchFile(*outputFile, 0x9A06, []byte{0x00, 0x61})

	// change where we load item info during levels, this is lvl 2, there's 5 reads we need
	// to adjust
	patchFile(*outputFile, 0x845B, []byte{0x40, 0x61})
	patchFile(*outputFile, 0x846B, []byte{0x41, 0x61})
	patchFile(*outputFile, 0x8475, []byte{0x42, 0x61})
	patchFile(*outputFile, 0x847F, []byte{0x43, 0x61})
	patchFile(*outputFile, 0x8493, []byte{0x43, 0x61})
	patchFile(*outputFile, 0x84A2, []byte{0x44, 0x61})

	patchFile(*outputFile, 0xAA2B, []byte{0x40, 0x61})
	patchFile(*outputFile, 0xAA3B, []byte{0x41, 0x61})
	patchFile(*outputFile, 0xAA45, []byte{0x42, 0x61})
	patchFile(*outputFile, 0xAA4F, []byte{0x43, 0x61})
	patchFile(*outputFile, 0xAA67, []byte{0x43, 0x61})
	patchFile(*outputFile, 0xAA74, []byte{0x44, 0x61})

	patchFile(*outputFile, 0xC455, []byte{0x40, 0x61})
	patchFile(*outputFile, 0xC467, []byte{0x41, 0x61})
	patchFile(*outputFile, 0xC471, []byte{0x42, 0x61})
	patchFile(*outputFile, 0xC47B, []byte{0x43, 0x61})
	patchFile(*outputFile, 0xC48F, []byte{0x43, 0x61})
	// world 3 doesn't have any chalices, I think it's a bug in the original game
	//patchFile(*outputFile, 0xAA74, []byte{0x44, 0x61})

	// text patches
	// Add alphabet to title screen
	patchFile(*outputFile, 0x3d30, titleTextAlphabet)
	patchFile(*outputFile, 0x63c3, titleText1)
	patchFile(*outputFile, 0x63e3, titleText2)
	patchFile(*outputFile, 0x6402, titleText3)
	patchFile(*outputFile, 0x6422, titleText4)

	// ending text
	patchFile(*outputFile, 0x10264, endingText1)
	patchFile(*outputFile, 0x110E6, endingText2)
	patchFile(*outputFile, 0x11116, endingTextUrl)
	patchFile(*outputFile, 0x1120, endingTextSlash)

	// fast text in rooms
	patchFile(*outputFile, 0x195F2, []byte{0x01})

	// updated text in password screen
	patchFile(*outputFile, 0x6B6E, passwordText)
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

func checkForPatchOverlap() error {

	for x := 0; x < len(patchInformation); x++ {
		for y := 0; y < len(patchInformation); y++ {
			if x == y {
				continue
			}

			x1 := patchInformation[x][0]
			x2 := patchInformation[x][1]

			y1 := patchInformation[y][0]
			y2 := patchInformation[y][1]

			if y1 >= x1 && y1 <= x2 {
				return fmt.Errorf("Patch %d (%x - %x) overlaps with patch %d (%x - %x)", x, x1, x2, y, y1, y2)
			}

			if x1 >= y1 && x1 <= y2 {
				return fmt.Errorf("Patch %d (%x - %x) overlaps with patch %d (%x - %x)", x, x1, x2, y, y1, y2)
			}

			if x2 >= y1 && x2 <= y2 {
				return fmt.Errorf("Patch %d (%x - %x) overlaps with patch %d (%x - %x)", x, x1, x2, y, y1, y2)
			}

			if y2 >= x1 && y2 <= x2 {
				return fmt.Errorf("Patch %d (%x - %x) overlaps with patch %d (%x - %x)", x, x1, x2, y, y1, y2)
			}
		}
	}

	return nil
}

func patchFile(outputFile string, offset int, patchBytes []byte) error {
	file, err := os.OpenFile(outputFile, os.O_RDWR, 0644)
	if err != nil {
		return err
	}

	defer file.Close()

	patchLength, err := file.WriteAt(patchBytes, int64(offset))
	if err != nil {
		return err
	}

	fmt.Printf("\nLength: %d bytes at %x", patchLength, offset)
	fmt.Printf("\nFile Name: %s", file.Name())

	patchStartEnd := make([]int, 2, 2)
	patchStartEnd[0] = offset
	patchStartEnd[1] = offset + patchLength - 1
	patchInformation = append(patchInformation, patchStartEnd)
	err = checkForPatchOverlap()
	if err != nil {
		panic(err)
	}
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
