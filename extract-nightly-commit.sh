#!/bin/sh

set -e

grep -e "^ENV ABCL_COMMIT" nightly/buster/Dockerfile | cut -d" " -f 3
