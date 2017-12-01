# adventofcode2017

## Day1
A CPP implementation. A simple for loop scans i-1 and i to check for matching.
I use a simple trick (ASCII/Unicode encoding exploit) to avoid calling atoi.
Subtracting zero puts a character in the range 0-9 into a numerical context.
No tests are written, no input is sanitized. Very naive implementation.
