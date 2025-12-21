#!/bin/sh

case "$(file -Lb --mime-type -- "$1")" in
    image/*)
        if [ "$TERM" = "linux" ]; then
            chafa -f symbols -s "$2x$3" --animate off --polite on "$1"
        else
            chafa -f sixel -s "$2x$3" --animate off --polite on "$1"
        fi
        exit 1
        ;;
    *)
        cat "$1"
        ;;
esac
