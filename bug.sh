#!/bin/bash

# This script demonstrates a race condition bug.

# Create two files.
touch file1.txt
touch file2.txt

# Function to write to a file.
write_to_file() {
  local file=$1
  local content=$2
  echo "$content" > "$file"
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

# Print the content of both files. This is where the bug occurs in the output.
read_from_file file1.txt
read_from_file file2.txt