#
# A trivial (and unnecessary) Makefile. If you want to run the script on Linux
# just make it executable using chmod. There's no install target because this
# is a bash script that should only be used to dump the bytes in small files.
#

SHELL = bash

SHELLFILES = bytedump.sh
PROGRAMS = bytedump
TESTFILES = test_bytes

all : $(PROGRAMS)

clean clobber :
	rm -f $(PROGRAMS) $(TESTFILES)

test_bytes :
	@echo "Building $@ test file"
	@LC_ALL=en_US.iso88591; \
	for hex in {0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}; do \
	    printf "%b" "\\u00$${hex}"; \
	done > "$@"

