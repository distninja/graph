#!/bin/bash

mkdir build

pushd build
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux"
    cmake ..
    cmake --build .
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Running on Windows (MinGW/MSYS/Cygwin)"
    CC=gcc CXX=g++ cmake -G "MinGW Makefiles" .. && mingw32-make -j4
fi
popd
