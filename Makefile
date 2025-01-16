#
# A trivial makefile for the bash version of the bytedump program. It doesn't
# even have an install target because this bash script is a demo that should
# only be used to dump the bytes in small files.
#

MAKEFILE = $(firstword $(MAKEFILE_LIST))

SHELLFILE = bytedump.sh
SORTED_BYTES = sorted_bytes

PROGRAM = $(SHELLFILE:.sh=)

all : $(PROGRAM) $(SORTED_BYTES)

clean :
	rm -f $(SORTED_BYTES)

clobber : clean
	rm -f $(PROGRAM)

#
# The sorted_bytes target builds a 256 byte file (named sorted_bytes) where each
# byte in the file contains the 8-bit binary representation of the byte's offset.
# It was was occasionally a useful bytedump test file. To see what's in the file
# type something like
#
#     ./bytedump --addr=decimal --byte=decimal --text=caret sorted_bytes
#
# or use any other bytedump options, and you should get a predictable dump that
# includes each possible byte exactly once.
#
# NOTE - this makefile currently uses make's default shell, and that undoubtedly
# means using /bin/echo (rather than the default shell's echo builtin) to handle
# hex expansions. An different approach would be to force bash on make by adding
#
#     SHELL = /bin/bash
#
# to the start of this file. After that, bash's brace expansion and its echo or
# printf builtins could be used to build the file. Even though using the default
# shell makes things a bit more complicated, I thought it might be instructive.
#

$(SORTED_BYTES) : $(MAKEFILE)
	@echo "Building the $@ test file"
	@for msd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
	    for lsd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
		/bin/echo -en "\\x$${msd}$${lsd}"; \
	    done; \
	done > "$@"

