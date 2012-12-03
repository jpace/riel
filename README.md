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

This class processes strings, wrapping them in ANSI colors.
