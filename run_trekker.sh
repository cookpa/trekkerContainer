#!/bin/bash

# Check if thread number is provided, and if not, set it to 1
threadsArg=""
threads=1

if [[ "$@" =~ -n[[:space:]]*([0-9]+) ]]; then
  threads=${BASH_REMATCH[1]}
elif [[ "$@" =~ --numberOfThreads[[:space:]]*([0-9]+) ]]; then
  threads=${BASH_REMATCH[1]}
else
  # If `-n` or `--numberOfThreads` is not provided, use default `-n 1`
  echo "Warning: no thread count specified. Defaulting to single thread"
  threadsArg="-n 1"
fi

# Run the command
echo "trekker parallel threads: $threads"
trekker $threadsArg "$@"