#!/bin/sh

set -e

grep -e "^ENV ABCL_COMMIT" nightly/buster/jdk-11/Dockerfile | cut -d" " -f 3
