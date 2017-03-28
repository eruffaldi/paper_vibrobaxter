#!/bin/bash
#
# Emanuele Ruffaldi 2017
#
# Takes a list of image files (supported by exiftool) and marks them with the current hash of the git branch or marking as hash-modified if it is not clean
#
# Writes: Subject and ImageUniqueID tags
#
# Lookup: exitfool filename | grep ImageUniqueID
if [ -n "$(git ls-files -m)" ] ; then 
Q="-modified";
else
Q="";
fi
S=$(git rev-parse --verify HEAD)${Q}
for var in "$@"
do
    exiftool -Subject="$S" -ImageUniqueID="$S" "$var"
done
