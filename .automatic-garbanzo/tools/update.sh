#!/bin/bash

# Update automatic garbanzo- run from top level of repository

if [ ! -d ".git" ] 
then
        echo "Run update script from the top level of your repository" >&2
        exit 1
fi

curl -L https://github.com/FredHutch/automatic-garbanzo/archive/2.0.2.tar.gz | tar -xzv --strip-components=1 -f -
