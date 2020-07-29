#!/bin/sh

RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m'

testdim()
{
    OUT=$(luajit main.lua $1 $2 100)
    difference=$(diff $1-$2-100.txt test-outputs/$1-$2-100.txt)
    if [ "${difference}" != "" ]
    then
        printf "${RED}X${NC} ${OUT}\n"
    else
        printf "${GREEN}O${NC} ${OUT}\n"
    fi
    rm $1-$2-100.txt
}

testdim 2 2
testdim 3 2
testdim 2 3
testdim 4 2
testdim 2 4

