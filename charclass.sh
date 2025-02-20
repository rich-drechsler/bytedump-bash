#!/bin/bash
#
# I originally used something like this to build the HEX lists that describe which
# bytes belong to the POSIX "character classes" that can be used on the command line
# to pick groups of bytes. Those HEX lists are important and they're used internally
# (by the bash implementation of bytedump) as arguments in many of the ByteSelector
# recursive calls. I didn't bother saving the original version of this script, so I
# was forced to rewrite it when I wanted to check those HEX lists again. Since there
# appears to be a little disagreement about three of those HEX lists, I felt it was
# important to include this script in the source code, primarily to document how I
# constructed the HEX lists.
#
# This all came up because I decided to take a close look at the HEX lists while I
# was implementing a Java version of the bash ByteSelector function. A few things
# seemed a little off, so I asked ChatGPT for some help. It took quite a few tries
# to "frame" the question properly, but eventually ChatGPT gave me decent, but not
# completely convincing answers about the HEX lists that are currently hardcoded in
# the bash version of bytedump. A quick look at the actual characters assigned to
# the first 256 Unicode code points seemed to provide a third, slightly different
# take on what belongs in the HEX lists that represent the "lower", "upper", and
# "punct" character classes.
#
# If you want to use this script, type
#
#     make charclass
#
# followed by commands that look something like
#
#     ./charclass lower
#     ./charclass upper
#     ./charclass punct
#     ./charclass cntrl
#
# to generate the HEX code lists used in various ByteSelector recursive calls that
# implement "character class" selection. In each case the output should match the
# HEX lists that are currently hardcoded in the bash implementation of the bytedump
# program.
#
# NOTE - at this point I can't explain the differences, but I don't think it's an
# urgent issue, so for now I'm not going to make any changes. This script documents
# how I built the existing HEX lists, but there definitely are some issues deserve
# investigation.
#

matchedbytes=()
bytes="TRUE"
missed=""
matched=""

while (( $# > 0 )); do
    case "$1" in
          +bytes) bytes="TRUE";;
          -bytes) bytes="";;
        +matched) matched="TRUE";;
        -matched) matched="";;
         +missed) missed="TRUE";;
         -missed) missed="";;
              --) shift; break;;
               *) break;;
    esac
    shift
done

if [[ $1 =~ ^[[:blank:]]*(alnum|alpha|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit)[[:blank:]]*$ ]]; then
    charclass="[:${BASH_REMATCH[1]}:]"
    shift
    for range in "${@:-00-FF}"; do
        if [[ $range =~ ^(([[:xdigit:]]+)([-]([[:xdigit:]]+))?)$ ]]; then
            first="16#${BASH_REMATCH[2]}"
            last="16#${BASH_REMATCH[4]:-${BASH_REMATCH[2]}}"
            for (( index = first; index <= last; index++ )); do
                state=""
                hex=$(printf "%.2X" "$index")

                #
                # Bash can't handle null bytes in strings and command substitution
                # tosses trailing newlines, so deal with them separately.
                #
                case "${hex^^}" in
                    00) char="";;
                    0A) char=$'\n';;
                     *) char=$(printf "%b" "\u00${hex}");;
                esac

                if [[ $char =~ ^[${charclass}]$ ]]; then
                    state="${matched:+"TRUE"}"
                    matchedbytes[index]="$hex"
                elif [[ $charclass == "[:cntrl:]" && $index == "0" ]]; then
                    state="${matched:+"TRUE"}"
                    matchedbytes[index]="$hex"
                else
                    state="${missed:+"FALSE"}"
                fi

                if [[ -n $state ]]; then
                    if [[ ${char} =~ [[:print:]] ]]; then
                        printf "HEX=%s, CHAR=%s: %s\n" "$hex" "$char" "$state"
                    else
                        printf "HEX=%s, CHAR=%s: %s\n" "$hex" "^$hex" "$state"
                    fi
                fi
            done
        fi
    done
fi

if [[ -n $bytes ]]; then
    if (( ${#matchedbytes[@]} > 0 )); then
        sep=""
        for (( index = 0; index < 256; index++ )); do
            if [[ -n ${matchedbytes[$index]} ]]; then
                first="$index"
                for (( last=index; index < 256; index++ )); do
                    if [[ -n ${matchedbytes[$index]} ]]; then
                        last=$index
                    else
                        break
                    fi
                done
                printf "%s%s" "$sep" "${matchedbytes[$first]}"
                if (( last > first )); then
                    printf -- "-%s" "${matchedbytes[$last]}"
                fi
                sep=" "
            fi
        done
        printf "\n"
    fi
fi

