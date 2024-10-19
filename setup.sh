#!/bin/sh
scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory"

for dir in */; do
    stow "$(basename "$dir")"
done
