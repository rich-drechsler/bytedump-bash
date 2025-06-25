##
## A makefile for the bash implementation of the bytedump program that was written
## for GNU make. Take a look at
##
##     https://www.gnu.org/software/make/manual/make.html
##
## if you want more information about GNU make. It's a big manual, and in the past
## I would occasionally use it as a reference, but today chatbots are the place to
## go for help with GNU make.
##
## A common complaint about makefiles is tab indentation that's required in recipes.
## I often use vim, and by default my .vimrc file tells vim to automatically expand
## tabs. That would break most makefiles, so I also include the line
##
##     autocmd FileType make setlocal noexpandtab
##
## in .vimrc to prevent tab expansion when vim decides I'm editing a makefile. You
## may have to deal with something similar whenever you edit makefiles.
##

#
# ROOT should point back at the repository's top directory. It's not currently used,
# but may be in the future.
#

ROOT := ..

#
# This makefile probably should be listed as a prerequisite in some of the rules, so
# we use GNU make's lastword function to grab its name. The technique is documented
# in an example in the GNU make manual, but it only works when the lastword function
# is called before any other makefile is included.
#
# NOTE - always assuming that name is Makefile is not unreasonable, but I wanted to
# show you what's suggested in the manual.
#

MAKEFILE := $(lastword $(MAKEFILE_LIST))

#
# The .DELETE_ON_ERROR target, if it's defined anywhere in the makefile, tells make
# to delete the target it's building if there's an error in the recipe that's being
# used. You might think this is GNU make's default behavior, but unfortunately it's
# not, so we force it.
#
# NOTE - targets like this one that start with a period don't count when make looks
# for the target to use as its "default goal", which is the target that make builds
# when there aren't any targets mentioned on the command line.
#

.DELETE_ON_ERROR :

#
# Bash bytedump specific definitions and rules.
#

BYTEDUMP := bytedump
CHARCLASS := charclass
SORTED_BYTES := sorted_bytes

all : $(BYTEDUMP)

clean :
	rm -f $(SORTED_BYTES) $(CHARCLASS)

clobber : clean
	rm -f $(BYTEDUMP)

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
# hex expansions. A different approach would be to force bash on make by adding
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

