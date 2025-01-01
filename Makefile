#
# A trivial (and unnecessary) Makefile. If you want to run the script on Linux
# just make it executable using chmod. There's no install target because this
# bash script should only be used as a demo or to dump bytes in small files.
#

SHELL = /bin/bash

SHELLFILES = bytedump.sh
PROGRAMS = bytedump
TESTFILES = test_bytes

all : $(PROGRAMS)

clean clobber :
	rm -f $(PROGRAMS) $(TESTFILES)

test_bytes : $(MAKEFILE_LIST)
	@echo "Building the $@ file"
	@LC_ALL=en_US.iso88591; \
	for hex in {0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}; do \
	    printf "%b" "\\u00$${hex}"; \
	done > "$@"

