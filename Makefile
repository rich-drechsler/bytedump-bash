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

####################
#
# Setup
#
####################

ROOT := ..					# repository root - currently unused
MAKEFILE := $(lastword $(MAKEFILE_LIST))	# name of this makefile

.DELETE_ON_ERROR :				# delete targets on build errors

####################
#
# Variables
#
####################

BYTEDUMP := bytedump
SORTED_BYTES := sorted_bytes

####################
#
# Rules
#
####################

all : $(BYTEDUMP)

clean :
	rm -f $(SORTED_BYTES)

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

$(SORTED_BYTES) : $(MAKEFILE)
	@echo "Building the $@ test file"
	@for msd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
	    for lsd in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do \
		/bin/echo -en "\\x$${msd}$${lsd}"; \
	    done; \
	done > "$@"

