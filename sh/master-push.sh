#!/bin/sh

cd `dirname $0`
echo -n "." >> _dot.md
git add _dot.md
git commit -m '🍌 add dot'
git push -u origin master
