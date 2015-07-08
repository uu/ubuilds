#!/bin/sh
#
for file in ./source/*.cc
do
   file=${file%.cc}
   g++ -fPIC -c $file.cc -Isource -I. -Iinclude -ljpeg -o $file.o
done
ld -G ./source/*.o -shared -o libyuv.so
