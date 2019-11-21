#!/usr/bin/env bash

USAGE="Usage: $0 name http://url_of_the_gif"
NAME_PATTERN=^[a-zA-Z0-9_-]+$
NAME=$1
URL=$2


function exit_with_msg
{
    echo "$2" 1>&2
    exit $1
}


# Usage 
[[ "$NAME" != "--help" ]] || exit_with_msg 0 "$USAGE"
[[ $# -eq 2 ]] || exit_with_msg 1 "$USAGE" 

# Ensure availability of wget
type wget > /dev/null 2> /dev/null || exit_with_msg 2 "Script requires wget"
type gifsicle > /dev/null 2> /dev/null || exit_with_msg 2 "Script requires gifsicle"

# Ensure NAME is correctly formed
[[ $NAME =~ $NAME_PATTERN ]] || exit_with_msg 3 "The name \"$NAME\" must match the regex \"$NAME_PATTERN\""

# Ensure NAME is not already in use
[[ ! -f "./_orig/$NAME.gif" ]] || exit_with_msg 4 "The name \"$NAME\" is already in use (see ./_orig/$NAME.gif)"

# Get the new GIF
wget "$URL" -O "./_orig/$NAME.gif" || exit_with_msg 5 "Problem getting GIF"

# Run ./process_gifs.sh
./process_gifs.sh || exit_with_msg 6 "Problem processing GIF"

