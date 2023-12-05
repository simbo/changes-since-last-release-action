#!/bin/bash

tag="$(git describe --tags --abbrev=0 @^ 2> /dev/null)"

echo "last-tag=$tag" >> $GITHUB_OUTPUT
