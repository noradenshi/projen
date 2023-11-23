#!/bin/bash
set -e

# About:
# Generates a C meson project
# Options: C=clang

# Structure:
#
# $name
#   /bin
#   /build
#   /src
#       main.c
#   meson.build 

mkdir bin src

cat <<- EOF > ./src/main.c
#include <stdio.h>

int main()
{
    printf("Hello world!\n");
    return 0;
}
EOF

cat <<- EOF > ./meson.build
project('$name', 'c',
  default_options: [
    'prefix=${PWD}',
    'c_std=c99'
  ]
)

executable('exe', 'src/main.c', install: true)
EOF

C=clang meson setup build
