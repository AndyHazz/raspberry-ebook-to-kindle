#!/bin/bash
# Script to convert .epub to .mobi files with calibre and email to kindle
# .mobi files sent straight to kindle
# requires ssmtp, mpack, calibre
######################################################################################
# Config #######################################################################
######################################################################################

# Email address for kindle
KINDLEEMAIL="andy.nmc@gmail.com"

# Directory to process from
LOC_IN="/home/pi/nfs/volume1/downloads/ebooks/_togo"

######################################################################################

# Create directories if they don't exist
mkdir "$LOC_IN/processing" -p
PROCESSING="$LOC_IN/processing"

mkdir "$LOC_IN/sent" -p
SENT="$LOC_IN/sent"

mkdir  "$LOC_IN/converted" -p
CONVERTED="$LOC_IN/converted"



# for each file passed, do the thing
for file in "$@"
do
  if [ -f $file ]
  then
    if [[ $file == *.mobi ]]
    then
      # send to kindle
      mv "$file" "$PROCESSING/$file"
      mpack -s "${file%.mobi}" "$PROCESSING/$file" $KINDLEEMAIL
      mv "$PROCESSING/$file" "$SENT/$file"
    fi
    if [[ $file == *.epub ]]
    then
      # convert then send to kindle
      mv "$file" "$PROCESSING/$file"
      ebook-convert "$PROCESSING/$file" "$CONVERTED/${file%.epub}.mobi"
      mpack -s "${file%.epub}" "$CONVERTED/${file%.epub}.mobi" $KINDLEEMAIL
      mv "$PROCESSING/$file" "$SENT/$file"
    fi
  fi
done
