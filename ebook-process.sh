#!/bin/bash
# Script to convert .epub to .mobi files with calibre and email to kindle
# .mobi files sent straight to kindle
# requires ssmtp, mpack, calibre
######################################################################################
# Config #######################################################################
######################################################################################

# Email address for kindle
KINDLEEMAIL="andyhazz@kindle.com"

######################################################################################

for file in "$@"
do
  if [ -f $file ]
  then
    if [[ $file == *.mobi ]]
    then
      # send to kindle
      mv "$file" "processing/$file"
      mpack -s "${file%.mobi}" "processing/$file" $KINDLEEMAIL
      mv "processing/$file" "sent/$file"
    fi
    if [[ $file == *.epub ]]
    then
      # convert then send to kindle
      mv "$file" "processing/$file"
      ebook-convert "processing/$file" "converted/${file%.epub}.mobi"
      mpack -s "${file%.epub}" "converted/${file%.epub}.mobi" $KINDLEEMAIL
      mv "processing/$file" "sent/$file"
    fi
  fi
done
