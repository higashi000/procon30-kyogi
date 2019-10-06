#!/bin/sh

echo -n "localserver ip >>"
read _mariIP
echo -n "localserver port >>"
read _mariPort
echo -n "最大ターン数 >>"
read _maxTurn
echo -n "自チームID >>"
read _myTeamID

# ローカルサーバーの起動
cd ./Mari/
./main $_mariIP $_mariPort $_myTeamID $_maxTurn &
cd ..

# solverの起動
cd ./Kanan
./kanan $_mariIP $_mariPort $_maxTurn
cd ..
