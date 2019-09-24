# procon30-kyogi

nit-ok prcon30競技部門のリポジトリ

## 動作環境
- Ubuntu18.04

## Library
- ldc2
- gin

## Install
### ldc2
以下のコマンドでldc2をダウンロード後，PATHを通す<br>
`curl -fsS https://dlang.org/install.sh | bash -s ldc`

### golang
以下のコマンドでインストール(go1.12じゃないと動かないかもしれない)
`sudo snap instal --classic go`
### gin
以下のコマンドでインストール
`go get -u github.com/gin-gonic/gin`

## How to use

- ビルド<br>
`sh ./build.sh`

- 実行<br>
`sh ./start.sh`

- 自作のゲームサーバーを用いての動作確認<br>
いい感じのフィールドのデータが書かれたjsonを`Sarah`ディレクトリに`A.json`という名前で置く<br>
その後に<br>
`sh ./test.sh`
