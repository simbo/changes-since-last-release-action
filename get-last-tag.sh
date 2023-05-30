#!/bin/bash

tag="$(git tag --list --sort=-version:refname "$1" | head -n 1 2> /dev/null)"

echo "last-tag=${tag}" >> "$GITHUB_OUTPUT"
