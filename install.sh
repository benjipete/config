#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

linkDotFile()
{
   if [ ! -f ~/$1 ]; then
       ln -vs ${DIR}/$1 ~/$1
   else
       echo "ignoring $1 as it already exists in ~/"
   fi
}

linkDotFiles()
{
    for i in `ls -A ${DIR} | egrep '^\.' | grep -v ".git"`
    do
        linkDotFile $i
    done
    linkDotFile .gitconfig
    linkDotFile .gitignore_global

}

linkDirectories()
{
    for i in `find ${DIR} -mindepth 1 -maxdepth 1 -type d | grep -v .git`
    do
        filename=$(basename $i)
        if [ ! -d ~/.config/${filename} ]; then
            ln -vs $i ~/.config/${filename}
        else
            echo "ignoring ${filename} is it already exists in .config"
        fi
    done
}

linkDotFiles
linkDirectories
