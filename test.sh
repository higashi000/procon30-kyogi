#!/bin/sh

cd ./Sarah
go run main.go &
cd ..

cd ./Mari
echo -n "localserver ip >>"
read _mariIP
echo -n "localserver port >>"
read _mariPort
echo -n "最大ターン数 >>"
read _maxTurn
echo -n "自チームID >>"
read _myTeamID

go run main.go &
cd ..

cd ./Kanan
dub build --compiler=ldc2 --build=release --
./kanan $_mariIP $_mariPort $_maxTurn
cd ..
