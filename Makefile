# Makefile to build Cardguesstest testing program

all:	Cardguesstest

OS=Cardguesstest.o Cardguess.o Response.o Card.o

Cardguesstest:	$(OS)
	ghc -package containers -o $@ $(OS)

%.o %.hi:	%.hs
	ghc -c $<

Cardguesstest.o:	Card.hi Cardguess.hi Response.hi

Response.o:	Card.hi
