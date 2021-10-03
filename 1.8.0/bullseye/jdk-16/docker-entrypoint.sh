#!/bin/sh

# If the first arg starts with a hyphen, prepend abcl to arguments.
if [ "${1#-}" != "$1" ]; then
	set -- abcl "$@"
fi

exec "$@"
