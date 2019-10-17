# procon30-kyogi

nit-ok prcon30競技部門のリポジトリ

## チームメンバー
- [ひがし](https://twitter.com/higashi136_2)
- [えびな](https://twitter.com/ebina_hoge)
- [ハラショー](https://twitter.com/harasho_man)
- [かりんと](https://twitter.com/k41t_)
- [らず](https://twitter.com/razu404)

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
以下のコマンドでインストール(go1.12じゃないと動かないかもしれない)<br>
`sudo snap instal --classic go`
### gin
以下のコマンドでインストール<br>
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
