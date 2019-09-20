#!/bin/sh

cd ./Mari
go build main.go
cd ..
cd ./Kanan
dub build --compiler=ldc2 --build=release --
cd ..
