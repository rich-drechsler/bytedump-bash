#
# A trivial makefile for the bash version of the bytedump program. It doesn't
# even have an install target because this bash script is a demo that should
# only be used to dump the bytes in small files.
#

SHELLFILES = bytedump.sh
PROGRAMS = bytedump
TESTFILES = all_bytes

all : $(PROGRAMS)

clean clobber :
	rm -f $(PROGRAMS) $(TESTFILES)

#
# The all_bytes target builds a 256 byte file (named all_bytes) where each byte
# in the file contains the 8-bit binary representation of the byte's offset. The
# file was occasionally a useful bytedump test file, so I added a target you can
# use to build it. All you have to do is type
#
#     make all_bytes
#
# and you should end up with a test file named all_bytes. To see what ended up
# in that file, type something like
#
#     ./bytedump --addr=decimal --byte=decimal --text=caret all_bytes
#
# or use any other options, and you should get a predictable dump that includes
# each possible byte exactly once.
#
# NOTE - this makefile currently uses make's default shell, and that undoubtedly
# means using /bin/echo (rather than the default shell's echo builtin) to handle
# hex expansions. An easier approach would be to force bash on make by adding
#
#     SHELL = /bin/bash
#
# to the start of this file. After that, bash's brace expansion and its echo or
# printf builtins could be used to build the file. Even though using the default
# shell makes things a bit more complicated, I thought it might be instructive.
#
# NOTE - another alternative (that should be supported by make's default shell)
# would be three nested for loops, octal escapes, and the echo builtin.
#

all_bytes : $(MAKEFILE_LIST)
	@echo "Building the $@ test file"
	@for msd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
	    for lsd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
		/bin/echo -en "\\x$${msd}$${lsd}"; \
	    done; \
	done > "$@"

