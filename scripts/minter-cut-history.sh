#!/usr/bin/env bash
#
# Script for experemental node which keep state changes in json files
#
MINTER_HOME=/home/minter
HISTORY_ROOT=${MINTER_HOME}/.minter/changes
HISTORY_DEPTH=240000

unset -v LAST_FILE
for file in ${HISTORY_ROOT}/*.json
do
 [[ $file -nt $LAST_FILE ]] && LAST_FILE=$file
done
unset -v file

LAST_FILE_NAME=${LAST_FILE##*/}
LAST_FILE_ID=${LAST_FILE_NAME%.*}
THRESHOLD_ID=$(( LAST_FILE_ID - HISTORY_DEPTH ))

#echo "HISTORY_DEPTH=$HISTORY_DEPTH"
#echo "LAST_FILE_ID=$LAST_FILE_ID"
#echo "THRESHOLD_ID=$THRESHOLD_ID"

if [[ $THRESHOLD_ID =~ ^[\-0-9]+$ ]] && (( THRESHOLD_ID > 0 )); then
  for file in ${HISTORY_ROOT}/*.json
  do
    FILE_NAME=${file##*/}
    FILE_ID=${FILE_NAME%.*}
   if (( FILE_ID < THRESHOLD_ID )); then
     #echo "$FILE_NAME to delete THRESHOLD_ID=$THRESHOLD_ID FILE_ID=$FILE_ID";
     rm -f ${file}
   fi
  done;
fi
