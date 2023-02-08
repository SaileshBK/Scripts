#!/bin/bash

# Get a list of all local Git repositories
repositories=$(find . -name ".git" -type d | sed 's/\/.git//')

# Loop through all local Git repositories
for repo in $repositories; do
  # Go to the repository directory
  cd "$repo"
  # Find all .html files
  for file in $(find . -name "*.html"); do
    # Remove extra empty lines from the file
    awk 'NF' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  done
  # Stage all changes
  git add .
  # Commit the changes
  git commit -m "Remove extra empty lines from .html files"
  # Fetch the latest changes from the remote repository
  git fetch origin
  # Update all local branches with their remote counterparts
  for branch in $(git branch | sed 's/^..//'); do
    if git rev-parse --verify --quiet "origin/$branch"; then
      git checkout "$branch"
      git rebase "origin/$branch"
    else
      git branch -D "$branch"
    fi
  done
  # Push the changes to the remote repository
  git push origin
  # Go back to the parent directory
  cd ..
done
