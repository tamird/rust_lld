#!/usr/bin/env sh

set -eu

# DEBUGGING CODE GOES HERE

echo "$@" > "$LD_PROCLINE_FILE"

if [ -f target/ld ]; then
	target/ld "$@"
else
	ld "$@"
fi
