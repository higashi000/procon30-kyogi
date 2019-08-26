# NIT-Ok procon30-kyogi client Mari

# サポート環境
Ubuntu18.04 LTS<br>

# 使い方
- 高専プロコン運営が配布してあるサーバーを起動(ポートは8080で)
- sourceフォルダ内で以下のコマンドを実行する

```
go run main.go ip_address port maxTurn
```

`ip_address`の部分はそれぞれのipを<br>
`port`の部分はport番号を<br>
`maxTurn`はその試合の最大ターン数を入れる<br>
