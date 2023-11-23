#!/bin/bash
set -e

# Projen - Bash Project Generator
# Author: noradenshi
# Github: noradenshi/projen
# License: MIT

if [ ! $# = 2 ]; then
    printf "Usage: $0 <lang> <name>";
    exit 0
fi

lang=${1,,}
name=$2
dir=$(dirname -- "$( readlink -f -- "$0"; )")

if [ ! -e $dir/bin/$lang.sh ]; then
    printf "Language $lang is not supported\n";
    exit 0;
fi

printf "Generating a ${lang^^} project named $name\nat ${PWD}\n";
read -p "Continue? (Y/n)" confirm;
if [[ $confirm = "n"  ||  $confirm = "N" ]]; then
    printf "Operation cancelled\n";
    exit 0;
fi

source $dir/bin/$lang.sh $name
