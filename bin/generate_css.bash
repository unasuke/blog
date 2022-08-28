#!/usr/bin/env bash

NODE_SASS_OPTIONS="--style=expanded --no-source-map"

for file in `ls -1 source/stylesheets/src/[!_]*.scss`; do
  sass $NODE_SASS_OPTIONS $file source/stylesheets/all.css;
done
