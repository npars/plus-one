#!/usr/bin/env bash

USAGE="Usage: ./add_gif.sh name http://url_of_the_gif"
NAME=$1
URL=$2

# Usage 
if [[ "$NAME" == "--help" ]]; then
    echo $USAGE
    exit 0
fi

if [[ $# -ne 2 ]]; then
    echo $USAGE
    exit 1
fi

# Ensure availability of wget
if ! type wget > /dev/null 2> /dev/null; then
    echo "Script requires wget"
    exit 2
fi

# Ensure name is not already in use
if [[ -f ./_orig/$NAME.gif ]]; then
    echo "The name $NAME is already in use (see ./_orig/$NAME.gif)"
    exit 3
fi

# Get the new GIF
wget $URL -O ./_orig/$NAME.gif

if [[ $? -ne 0 ]]; then
    echo "Problem getting GIF"
    exit 4
fi

# Run ./process_gifs.sh
./process_gifs.sh

if [[ $? -ne 0 ]]; then
    echo "Problem processing GIF"
    exit 5
fi

