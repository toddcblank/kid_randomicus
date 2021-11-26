package main

import (
	"encoding/hex"
	"fmt"
)

func printMaze(maze []byte) string {
	htmlSpoiler := "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheets/dungeon.css\" /></head><body>"
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
				line = line + "<img class=\"opening-img\" src=\"../images/fortresses/open-up.png\" />\n"
			}

			if (openings & 0x02) == 0x02 {
				line = line + "<img class=\"opening-img\" src=\"../images/fortresses/open-right.png\" />\n"
			}

			if (openings & 0x04) == 0x04 {
				line = line + "<img class=\"opening-img\" src=\"../images/fortresses/open-down.png\" />\n"
			}

			if (openings & 0x08) == 0x08 {
				line = line + "<img class=\"opening-img\" src=\"../images/fortresses/open-left.png\" />\n"
			}

			// var enemy = mazeBytes[Math.floor(index/2) + 128];
			// if (enemy != 0x00 && ((enemy & 0xf0) != 0x50)) {
			// line += '<img class=\"opening-img\" src=\"../images/enemies/' + enemy.toString(16) + '.png\" />';
			// }
			line = line + "<img class=\"roomImage\" src=\"../images/fortresses/" + imgName + "\"/></div>\n"
		}
	}
	htmlSpoiler = htmlSpoiler + line
	htmlSpoiler = htmlSpoiler + "<div></body></html>\n"

	return htmlSpoiler
}

func main() {

	mazeStr := "0A00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102170C0000000000000702170E1A0A080E150900000000000008040E051402280B130E1E08000000001F07260D0106210E200F260E0F081B040B00200B030B1E0B280B280B070A0409"

	data, err := hex.DecodeString(mazeStr)
	if err != nil {
		panic(err)
	}

	fmt.Println(printMaze(data))
}
