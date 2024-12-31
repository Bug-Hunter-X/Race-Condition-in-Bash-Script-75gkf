#!/bin/bash

# This script demonstrates a solution to the race condition bug using flock.

# Create two files.
touch file1.txt
touch file2.txt

# Function to write to a file using flock for locking.
write_to_file() {
  local file=$1
  local content=$2
  flock -x "$file" || exit 1
  echo "$content" > "$file"
  flock -u "$file"
}

# Function to read from a file.
read_from_file() {
  local file=$1
  cat "$file"
}

# Start two parallel processes.
pid1=$($BASH -c 'write_to_file file1.txt "Hello"' & echo $!) 
pid2=$($BASH -c 'write_to_file file2.txt "World"' & echo $!) 

# Wait for both processes to finish.
wait $pid1 $pid2

# Print the content of both files. The output is now deterministic.
read_from_file file1.txt
read_from_file file2.txt