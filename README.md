# Kid Randomicus
Pure ROM Kid Icarus randomizer

Contains several 6502 asm files and helper scripts that randomizes several features of Kid Icarus.  This is essentially ROM hack that implements the Kid Icarus Randomizer developed by myself and FruitBatSalad.

For World 1 & World 3 the asm replaces the routine that copies the level data and instead programatically generates a completeable level.  For World 2, we actually choose the next screen via randomization logic rather than pre-generating the level.  

For the fortresses I generate a path so that they should be completable from any room that you can get to.  This does not count going into the corner of a room that is a deadend in and of itself, so don't go anywhere that you shouldn't =)


It also contains a shell script that lets you easily move around where in the rom the code lives, and builds the asm and patches the rom using the go program.

The go file is used to automate the patching of a Kid Icarus rom for the couple dozen patches that the romhack requires.

Specifically it randomizes:
* The screens in the scrolling levels.  These will be randomized every load, which means it'll change on death
* Doors in World 1 & World 3.  There's no guarentee on the number or types of rooms you'll find
* Doors in World 2 will always be the same, and always at the end of the levels (Strength Upgrade in 2-1, Challenge room in 2-2, and Black Market in 2-3)
* Fortresses - These are randomized once per playthrough, so if you die they will remain the same
* Enemies in Fortresses - If you see Eggplant Wizards be careful!  There might not be a hospital!

Quality of Life Patches:
* Removed the hidden score requirement for upgrade rooms
* Adjusted prices to be more reasonable
* Pencil, Map, and Torch functionality are enabled by default in the fortresses
* The pause screen will show a "seed" value for the current level.  This is helpful for me if you run into something that shouldn't happen, I can recreate the same level to investigate
* Updated Title Screen & Credits to shout out all the people that have contributed to the randomizer

Things I had to remove because I didn't want to deal with them
* Moving Platforms - these don't play nice with doors and some enemies, so rather than try to solve that in limited space, I removed all screens with platforms
* Centurions in Fortresses - their default placement would sometimes block exits that I don't account for in the fortress generation

Known Bugs:
* Pot Rooms in world 3 are jumbled
* You can jump over the exit screens in World 2, I suggest you refrain from doing so

