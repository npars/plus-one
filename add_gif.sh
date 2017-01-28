#!/bin/bash

# Usage: ./add_gif.sh name http://url_of_the_gif
NAME=$1
URL=$2

# Usage 
if [ "$NAME" = "--help" ]; then
    echo Usage: ./add_gif.sh name http://url_of_the_gif
    exit 0
fi

# Ensure no local changes to start with
if ! git diff-index --quiet HEAD --; then
    echo "Only run this script with no local git changes; maybe 'git stash' first?"
    exit 1
fi

# Ensure the existence of a 'mine' remote 
if ! git remote -vv | grep '^mine.*(push)$'; then
    echo "To use this script, you should have a remote called 'mine', from which pull requests can be created"
    exit 2
fi

# Ensure availability of wget and hub
if ! type wget > /dev/null 2> /dev/null; then
    echo "Script requires wget"
    exit 3
fi

if ! type hub > /dev/null 2> /dev/null; then
    echo "Script requires hub; see https://github.com/github/hub"
    exit 4
fi

# Ensure name is not already in use
if [ -f ./_orig/$NAME.gif ]; then
    echo "The name $NAME is already in use (see ./_orig/$NAME.gif)"
    exit 5
fi

# Get the new GIF
wget $URL -O ./_orig/$NAME.gif

if [ $? -ne 0 ]; then
    echo "Problem getting GIF"
    exit 6 
fi

# Run ./process_gifs.sh
./process_gifs.sh

if [ $? -ne 0 ]; then
    echo "Problem processing GIF"
    exit 7 
fi

# Push changes to 'mine' remote
BRANCH_NAME=topic/add_gif_for_$NAME
git checkout origin gh-pages
git checkout -b $BRANCH_NAME
git add .
git commit -m "Add $NAME GIF"
git push mine $BRANCH_NAME

# Open a new PR using https://github.com/github/hub
hub pull-request -m "Add GIF for $NAME" -b npars/plus-one:gh-pages

