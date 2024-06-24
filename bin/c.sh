#!/bin/bash
set -e

# About:
# Generates a C meson project

# Structure:
#
# $name
#   /bin
#   /build
#   /src
#       main.c
#   meson.build 

std=("c89" "c99" "c11" "c17" "c2x")
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
    'c_std=${std[$std_ch]}'
  ]
)

dir = meson.current_source_dir()

executable('exe', 'src/main.c',
  install_dir: dir + '/bin',
  install: true)
EOF

C=clang meson setup build
