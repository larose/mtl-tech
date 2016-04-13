#!/bin/bash
#
# How to clone
#
# * Create a repo, e.g. git@github.com:example-user/example-repo.git
# * Run clone script: $ ./clone.sh git@github.com:example-user/example-repo.git "Tim Hortons Locations"
# * Clone git@github.com:example-user/example-repo.git and populate the orgs with your desired items (e.g. Tim Hortons locations)
# * Run "make deploy" to get example-user.github.io/example-repo to display your Tim Hortons Locations map
#
# Purpose of cloning: use the base of this repo (interactive map with json map entries defined in orgs/ directory) for any purpose
#
# Example: http://sevagh.github.io/world-wonders/
#

if [ z"$1" == z"" ] || [ z"$2" == z"" ]; then
    echo "Usage: $0 git_url page_title"
    exit 255
fi

git stash
git checkout -b clone_branch
git remote add clone $1
cp orgs/adgear.json ./
rm -rf orgs/*
mv adgear.json orgs/sample.json
echo "Cloned from https://github.com/larose/mtl-tech" > README.md
sed -i "s#git@github.com.*.git#$1#g" Makefile
sed -i "s#Mtl-Tech#$2#g" static/index.html
sed -i "s#larose/mtl-tech#$(echo $1 | cut -d':' -f2 | sed 's/.git//g')#g" static/script.js
git add -A
git commit -m "cloned" 2>&1 > /dev/null
git push -fu clone clone_branch:master
git remote remove clone
git checkout master
git branch -D clone_branch
git stash pop

echo "Clone $1 to access your new clone"
