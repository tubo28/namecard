# 名札生成スクリプト

## できること

背景画像と個人ごとの名前、所属、アイコン画像が含まれる名札を作成し、PDF 形式で出力します。`namecards.pdf` がサンプルです。

## 使い方

1. `data.csv` に名札を作りたい人の名前、所属、アイコン画像へのパスを記述する。
2. `icon` ディレクトリにアイコン画像を置く。
3. `background.png` (背景画像) を編集する。
4. `main.rb` を編集し、名札のレイアウトを調整する。 (optional)
5. `bundle install`
6. `bundle exec ruby main.rb`
