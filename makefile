# program name
CC = gcc # compiler
AR = ar # archive
RANLIB = ranlib # used to generate an index to the contents of an archive and store it in the archive.

# flags
CFLAGS = -Wall # compilation flags
LFLAGS = -shared # linking flags
SFLAGS = rcu # static library flags
FPIC = -fPIC # position independent code flag

# files
# the file extention will be added by hand.
MAIN = main
HEADER = NumClass.h
BASIC = basicClassification
LOOP = advancedClassificationLoop
REC = advancedClassificationRecursion

# libraries 
STAT_LIB_LOOP = libclassloops.a # static library for the loop
DYN_LIB_LOOP = libclassloops.so # dynamic library for the loop
STAT_LIB_REC = libclassrec.a # static library for the recursive
DYN_LIB_REC = libclassrec.so # dynamic library for the recursive

# commands
# will compile all the libraries and the mains programs.
# if the program is already exists, do not compile it again.

# .PHONY - will tell the makefile that the following targets are not files.
.PHONY: clean all loops loopd recursives recursived

all: loops loopd recursives recursived mains maindrec maindloop

# create the files
$(MAIN).o: $(MAIN).c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@

$(BASIC).o: $(BASIC).c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@ $(FPIC)

$(LOOP).o: $(LOOP).c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@ $(FPIC)

$(REC).o: $(REC).c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@ $(FPIC)

# static loop

# create the library
loops: $(STAT_LIB_LOOP)

$(STAT_LIB_LOOP): $(LOOP).o $(BASIC).o
	$(AR) $(SFLAGS) $@ $^
	$(RANLIB) $@

# not need for main program

# dynamic loop

# create the library
loopd: $(DYN_LIB_LOOP)

$(DYN_LIB_LOOP): $(LOOP).o $(BASIC).o
	$(CC) $(LFLAGS) $(CFLAGS) $^ -o $@

# create the main program
maindloop: $(MAIN).o $(DYN_LIB_LOOP)
	$(CC) $(CFLAGS) $< ./$(DYN_LIB_LOOP) -o $@

# ~ static recursive ~

# create the library
recursives: $(STAT_LIB_REC)

$(STAT_LIB_REC): $(REC).o $(BASIC).o
	$(AR) $(SFLAGS) $@ $^
	$(RANLIB) $@

# create the main program 
mains: $(MAIN).o $(STAT_LIB_REC)
	$(CC) $(CFLAGS) $< ./$(STAT_LIB_REC) -o $@

# dynamic recursive
# create the library
recursived: $(DYN_LIB_REC)

$(DYN_LIB_REC): $(REC).o $(BASIC).o
	$(CC) $(LFLAGS) $(CFLAGS) $^ -o $@

# create the main program
maindrec: $(MAIN).o $(DYN_LIB_REC)
	$(CC) $(CFLAGS) $< ./$(DYN_LIB_REC) -o $@

# will remove all the libraries and the mains programs.
# only the .txt, .c, .h and the makefile files will remain.
clean: 
	rm -f *.o *.a *.so *.gch mains maindrec maindloop
