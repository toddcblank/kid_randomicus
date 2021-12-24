# Fortress Maze visualization utility
This program and associated css/images are used to take a 128 byte string of a generated fortress and output an html visualaztion of the maze.

## Usage

```printmaze.exe <256 character maze string> > maze.html```

or

```go run printmaze.go <256 character maze string> > maze.html```

The 128 bytes that you need to copy will be located at `$70AF` in the NES's RAM.