#!/bin/bash

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

echo -e "\033[0;32mRemoving public directory...\033[0m"
# Ensure the public folder is gone
rm -rf public

echo -e "\033[0;32mRunning hugo...\033[0m"
# Build the project.
hugo

echo -e "\033[0;32mChanging to public folder\033[0m"
# Move to the public dir
cd public

echo -e "\033[0;32mRunning git add -A...\033[0m"
# Add changes to git.
git add -A

echo -e "\033[0;32mRunning git commit...\033[0m"
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
echo -e "\033[0;32mPushing origin master...\033[0m"
git push origin master
echo -e "\033[0;32mPushing subtree...\033[0m"
# git subtree push --prefix=public git@github.com:charliegriefer/charliegriefer.github.io.git public

cd ..

echo -e "\033[0;32mRemoving public directory...\033[0m"
# Ensure the public folder is gone
# rm -rf public
