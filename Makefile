CC=g++
CFLAGS=-I. -g -Wall
LDFLAGS=
LIBS=-lm

FILES = day1.cpp

%.o: %.cpp $(FILES)
	$(CC) -c -o $@ $< $(CFLAGS)

%: %.o
	$(CC) -o $@ $< $(LDFLAGS) $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o 

