#
# A trivial (and unnecessary) Makefile. If you want to run the script on Linux
# just make it executable using chmod. There's no install target because this
# is a bash script that should only be used to dump the bytes in small files.
#

SHELLFILES = bytedump.sh
PROGRAMS = bytedump

all : $(PROGRAMS)

clean clobber :
	rm -f $(PROGRAMS)

