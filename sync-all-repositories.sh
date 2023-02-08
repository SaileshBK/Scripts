#!/bin/bash

# Get a list of all local Git repositories
repositories=$(find . -name ".git" -type d | sed 's/\/.git//')

# Loop through all local Git repositories
for repo in $repositories; do
  # Go to the repository directory
  cd "$repo"
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
  # Go back to the parent directory
  cd ..
done
