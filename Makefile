#
# A trivial (and unnecessary) Makefile. If you want to run the script on Linux
# just make it executable using chmod. There's no install target because this
# bash script should only be used as a demo or to dump bytes in small files.
#

SHELLFILES = bytedump.sh
PROGRAMS = bytedump
TESTFILES = all_bytes

all : $(PROGRAMS)

clean clobber :
	rm -f $(PROGRAMS) $(TESTFILES)

#
# Next target builds a 256 byte file where the numeric value of the byte stored
# at any offset in the file is the 8-bit value of that offset. Was occasionally
# useful as bytedump test file, so I added a target to build it.
#
# NOTE - if we use make's default shell we need to use /bin/echo to handle the
# hex expansion. An easier approach for this makefile probably would be to force
# bash on make by adding
#
#     SHELL = /bin/bash
#
# to the start of this file - after that bash's echo builtin should work. Even
# though this is a bit more complicated, I thought it might be instructive.
#

all_bytes : $(MAKEFILE_LIST)
	@echo "Building the $@ test file"
	@for msd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
	    for lsd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
		/bin/echo -en "\\x$${msd}$${lsd}"; \
	    done; \
	done > "$@"

