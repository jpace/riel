RIEL - Extensions to core Ruby libraries
============================================================

## DESCRIPTION

RIEL is a library that extends core Ruby libraries. It includes a logging
framework, an option processor, highlighting of strings.

## CLASSES

### Array

The core Array class is extended for better output of `to_s`, to output strings
in the format: [ "this", "is", "a", "test" ], instead of the default,
"thisisatest".

The `rand` method, equivalent to Array#sample, returns a random element from an
array.

### Command

The method `run` runs a command, returning the lines of output, and optionally
calling a block with each line, and the line number, if the block takes two
arguments.

### ANSIHighlighter

This class wraps strings in ANSI colors. For example:

    "foo".blue
    "bar".bold.blue.on_white

It also handles RGB values (on a 0-5 scale, not 0-255):

### SetDiff

This class compares enumerables as sets, A fully including B, B fully including
A, or A and B having common elements.

### AnsiPalette

This class prints the set of ANSI colors as foregrounds and backgrounds.

### ANSIITable

This class prints a spreadsheet-like table of data.
