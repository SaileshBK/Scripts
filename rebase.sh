#!/bin/bash

# Check if the current branch is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "Your branch is not clean. Please commit or stash your changes."
  exit 1
fi

# Fetch the latest changes from the remote repository
git fetch

# Rebase the current branch onto the latest version of the upstream branch
git rebase origin/master

if [ $? -ne 0 ]; then
  echo "Rebase failed. Please resolve the conflicts and run 'git rebase --continue'"
  exit 1
fi

echo "Rebase successful!"
