#!/bin/bash

tag="$(git describe --tags --abbrev=0 @^ 2> /dev/null)"

echo "::set-output name=last-tag::$tag"
