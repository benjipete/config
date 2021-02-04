#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

linkDotFiles()
{
    for i in `ls -A ${DIR} | egrep '^\.' | grep -v ".git"`
    do
        if [ ! -f ~/$i ]; then
            ln -vs ${DIR}/$i ~/$i
        else
            echo "ignoring $i as it already exists in ~/"
        fi

    done

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
