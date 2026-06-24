#!/bin/bash
# Simple script to add a package to the reprepro repository
# Usage: ./add-package.sh <path-to-deb-file>

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-deb-file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File $1 not found"
    exit 1
fi

cd "$(dirname "$0")"
reprepro -Vb . includedeb jammy "$1"