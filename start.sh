#!/bin/sh

echo -n "localserver ip >>"
read _mariIP
echo -n "localserver port >>"
read _mariPort
echo -n "最大ターン数 >>"
read _maxTurn
echo -n "自チームID >>"
read _myTeamID
echo -n "運営鯖 >> "
read _uneisaba
echo -n "thinking time >> "
read _thinkingTime

# ローカルサーバーの起動
cd ./Mari/
gnome-terminal -- ./main $_mariIP $_mariPort $_myTeamID $_maxTurn $_uneisaba $_thinkingTime &
cd ..

sleep 1

# solverの起動
cd ./Kanan
./kanan $_mariIP $_mariPort $_maxTurn
cd ..
