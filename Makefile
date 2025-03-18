CXX=g++
CPPFLAGS=-std=c++11

compile: cmos.l
	flex cmos.l
	$(CXX) $(CPPFLAGS) lex.yy.c -o lexer
	$(CXX) $(CPPFLAGS) cmos.cpp -o cmos

clean:
	rm -f *.o cmos lex.yy.c PlagiarismReport.txt