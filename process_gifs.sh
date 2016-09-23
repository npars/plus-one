#!/usr/bin/env bash
cd "$(dirname "$BASH_SOURCE")"
cd _orig
for f in *.gif; do
    if [ ! -f ../gifs/"$f" ]; then
        gifsicle --resize-width 300 -O3 "$f" -o ../gifs/"$f"
    fi
    if [ ! -f ../static/"$f" ]; then
        gifsicle --resize-width 300 -O3 "$f" '#0' -o ../static/"$f"
    fi
done
