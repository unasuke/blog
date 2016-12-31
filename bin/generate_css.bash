#!/usr/bin/env bash

NODE_SASS_OPTIONS="--output-style=expanded"

for file in `ls -1 source/stylesheets/src/[!_]*.scss`; do
  node-sass $file $NODE_SASS_OPTIONS -o source/stylesheets/;
done
