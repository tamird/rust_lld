#!/usr/bin/env sh

# DEBUGGING CODE GOES HERE

if [ -e target/ld ]; then
	target/ld "$@"
else
	ld "$@"
fi
