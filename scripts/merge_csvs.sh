#!/bin/bash

prefix="gh_repo___ranking_"

first_file="$prefix$(printf "%d" 1).csv"

echo "Merging CSV files..."
# ensure newline add end of file
# OSX: sed -i '' -e '$a\' $first_file
# Linux: sed -i'' -e '$a\' $first_file
sed -i '' -e '$a\' $first_file
mv $first_file "$prefix.csv"

for i in {2..11}
do
  current_file="$prefix$(printf "%d" $i).csv" 
  # ensure newline add end of file
  # OSX: sed -i '' -e '$a\' $current_file
  # Linux: sed -i'' -e '$a\' $current_file
  sed -i '' -e '$a\' $current_file
  tail -n +2 $current_file >> "$prefix.csv"
  rm $current_file
done

# remove all empty lines
echo "Removing empty lines from CSV file..."
# OSX: sed -i '' -e '/^\s*$/d' "$prefix.csv"
# Linux: sed -i'' -e '/^\s*$/d' "$prefix.csv"
sed -i '' -e '/^\s*$/d' "$prefix.csv"
