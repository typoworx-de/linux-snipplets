#!/bin/sh

# Load the global Xmodmap file if it exists
if [ -f /etc/X11/Xmodmap ];
then
    grep -v '^\s*#' /etc/X11/Xmodmap | xmodmap -
elif [ -f /usr/local/scratches/etc/X11/Xmodmap ];
then
    grep -v '^\s*#' /usr/local/scratches/etc/X11/Xmodmap | xmodmap -
fi
