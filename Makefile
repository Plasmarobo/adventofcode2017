CC=g++
CFLAGS=-I.
LDFLAGS=
LIBS=-lm

FILES = day1.cpp

%.o: %.cpp $(FILES)
	$(CC) -c -o $@ $< $(CFLAGS)

%.bin: %.o
	$(CC) -o $@ $< $(LDFLAGS)

.PHONY: clean

clean:
	rm -f *.o 

