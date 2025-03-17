CXX=g++
CPPFLAGS=-Wall -Werror -std=c++11

TARGETS=cmos

all: ${TARGETS}

clean:
	rm -f ${TARGETS} *.o