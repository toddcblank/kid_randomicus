# kid_randomicus
Pure ROM Kid Icarus randomizer

Contains an 6502 asm file that randomizes the scrolling levels in Kid Icarus.  The asm replaces the routine that copies the level data and instead programatically generates a completeable level.

The go file is used to automate the patching of a Kid Icarus rom as well as patching the rom to jump to our new routine instead of running the old routine.

It also contains a shell script that lets you easily move around where in the rom the code lives, and builds the asm and patches the rom using the go program.
