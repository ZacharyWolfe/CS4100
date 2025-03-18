CXX=g++
CPPFLAGS=-Wall -Werror -std=c++11

TARGETS=cmos

compile: cmos
	flex cmos.l
	$(CXX) $(CPPFLAGS) lex.yy.c -o cmos



clean:
	rm -f ${TARGETS} *.o