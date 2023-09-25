#!/bin/sh
# prepend_date: prefix each file with its modified date

# backup the 'field separator' characters and remove spaces from current IFS.
# this allows handling of files with spaces.

# added file renaming (replacing spaces with underscores)
# (c) Steffen Buhlert 12.02.2022

FMT="%Y%m%d-"
FML="%Y-%m-%d_"
FMH="%Y%m%d_%H%M-"

[ "-l" = "$1" ] && FMT="$FML" && shift;
[ "-t" = "$1" ] && FMT="$FMH" && shift;
[ "-h" = "$1" ] && FMT="$FMH" && shift;
[ "-s" = "$1" ] && shift;

SAVEIFS=$IFS
IFS=$'\t\n'

# this for loop iterates through all of the files that we gave the program
# it does one rename per file given

for file in $*
do
    mv $file ${file// /_}
    file=${file// /_}
# replace spaces in file name with underscore
    if [ -f $file -o -d $file ]
    then
		    mv -i ${file} "$(/usr/bin/stat -t $FMT -f %Sm $file)${file}"
    else
        echo "${file} is not a file"
    fi
done

# reset the IFS
IFS=$SAVEIFS

exit 0
