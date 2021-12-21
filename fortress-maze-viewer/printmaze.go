package main

import (
	"encoding/hex"
	"fmt"
	"os"
)

func printMaze(maze []byte) string {
	htmlSpoiler := "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheets/dungeon.css\" /></head><body>"
	htmlSpoiler = htmlSpoiler + "<div class=\"maze\">"

	line := ""
	for y := 0; y < 8; y++ {
		for x := 0; x < 8; x++ {

			imgName := "00.png"
			var openings byte

			idx := ((y * 8) + x) * 2
			room := maze[idx]
			openings = maze[idx+1]

			if room != 0x0 {
				imgName = fmt.Sprintf("%02x", room) + ".png"
			}

			openingsStr := fmt.Sprintf("%02x", openings)
			line = line + "<div class=\"room open-" + openingsStr + "\">\n"
			if (openings & 0x01) == 1 {
				line = line + "<img class=\"opening-img\" src=\"images/fortresses/open-up.png\" />\n"
			}

			if (openings & 0x02) == 0x02 {
				line = line + "<img class=\"opening-img\" src=\"images/fortresses/open-right.png\" />\n"
			}

			if (openings & 0x04) == 0x04 {
				line = line + "<img class=\"opening-img\" src=\"images/fortresses/open-down.png\" />\n"
			}

			if (openings & 0x08) == 0x08 {
				line = line + "<img class=\"opening-img\" src=\"images/fortresses/open-left.png\" />\n"
			}

			// var enemy = mazeBytes[Math.floor(index/2) + 128];
			// if (enemy != 0x00 && ((enemy & 0xf0) != 0x50)) {
			// line += '<img class=\"opening-img\" src=\"./images/enemies/' + enemy.toString(16) + '.png\" />';
			// }
			line = line + "<img class=\"roomImage\" src=\"images/fortresses/" + imgName + "\"/></div>\n"
		}
	}
	htmlSpoiler = htmlSpoiler + line
	htmlSpoiler = htmlSpoiler + "<div></body></html>\n"

	return htmlSpoiler
}

func main() {

	mazeStr := os.Args[1]

	//mazeStr := "00000000000000002900190E280A170C000000000000000021041A07020A020D00000000000008042107190D0C040E01000000000A040107260F200F190F150C000000000F070E0F020F0E0F190F190D000026061E0F150F150F0C0F140B28091706150F0E0F1E0F030F030F260E150C2703200B080B040B0C0B1E0B020B0A09"

	data, err := hex.DecodeString(mazeStr)
	if err != nil {
		panic(err)
	}

	fmt.Println(printMaze(data))
}
