#!/bin/bash
set -e

# About:
# Generates a C++ meson project

# Structure:
#
# $name
#   /bin
#   /build
#   /src
#       main.cpp
#   meson.build 

std=("c++98" "c++11" "c++14" "c++17" "c++20" "c++23" "c++2c")
printf "Valid standards:\n";
i=0
for f in ${std[@]}; do
    printf "$i) $f\n"
    i=$((i+1))
done

std_ch=-1
while [[ $std_ch -ge $i || $std_ch -lt 0 ]]; do
   read -p "Select id: " std_ch
done

mkdir $name
cd $name

mkdir bin src

cat <<- EOF > ./src/main.cpp
#include <iostream>

int main()
{
    std::cout << "Hello world!\n";
    return 0;
}
EOF

cat <<- EOF > ./meson.build
project('$name', 'cpp',
  default_options: [
    'prefix=${PWD}',
    'cpp_std=${std[$std_ch]}'
  ]
)

executable('exe', 'src/main.cpp', install: true)
EOF

CXX=clang++ meson setup build
