
# Technical exercise - Bitmap Editor

Rafa Garcia - 12/02/2020

---

## Requirements

Any stable distribution of Ruby MRI v2.3 or newer should do.

---

## Program input

The input consists of a file containing a sequence of commands, where a command is represented by a single capital letter at the beginning of the line. Parameters of the command are separated by white spaces and they follow the command character.
Pixel coordinates are a pair of integers: a column number between 1 and 250, and a row number between 1 and 250. Bitmaps starts at coordinates 1,1. Colours are specified by capital letters.

---

## Commands

There are 6 supported commands:

- I N M - Create a new M x N image with all pixels coloured white (O).
- C - Clears the table, setting all pixels to white (O).
- L X Y C - Colours the pixel (X,Y) with colour C.
- V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
- H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
- S - Show the contents of the current image

---

## Running the app

To run the application you must supply a command file. From the root directory, execute:

```bash
$: ./bin/bitmap_editor [FILE_PATH]
```

The script takes a file path as an argument.

---

## Running the tests

Providing the command line interpreter is at the root directory of the project, simply execute:

```bash
$: ./bin/test
```
