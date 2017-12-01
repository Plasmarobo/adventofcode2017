# adventofcode2017

## Day1
A CPP implementation. A simple for loop scans i-1 and i to check for matching.
I use a simple trick (ASCII/Unicode encoding exploit) to avoid calling atoi.
Subtracting zero puts a character in the range 0-9 into a numerical context.
No tests are written, no input is sanitized. Very naive implementation.
### Part 2
The previous implementation was not reusable. It was replaced with a ringbuffer implementation with a second comparison iterator. It can technically start anywhere, but will advance in lockstep with the primary iterator.

An extension would make the iterators overridable classes, and supply a difference starting point. This model would allow slower/faster iterators as well.
