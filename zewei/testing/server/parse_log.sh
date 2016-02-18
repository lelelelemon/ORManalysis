#!/bin/bash

fin=$1

while IFS='' read -r line || [[ -n "$line" ]]; do
#  echo $line
  if [[ $line == Started* ]]; then
    echo $line


  fi
done < $fin
