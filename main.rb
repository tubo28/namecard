#!/usr/bin/env ruby
# coding: utf-8
require 'prawn'
require 'csv'

# カードの大きさ
CARD_HEIGHT, CARD_WIDTH = 155, 258
# カードとカードの間
PADDING_Y, PADDING_X = 2, 2
# 左下カードの角の座標
START_Y, START_X = 20, 40
# 背景デザイン画像
BACK_GROUND = './background.png'
# 各カードの左上角を(0,0)としたアイコンの相対座標
ICON_Y, ICON_X = 58, 15
# アイコン画像の大きさ
# 正方形でない場合は、縦横比を保ち横幅がこの値になるように
ICON_SIZE = 70
# 名前の座標
NAME_Y, NAME_X = 63, 40
# 所属の座標
AFFIL_Y, AFFIL_X = 100, 40

def draw_card(id, aff, icon, idx)
  # 次の行は、prawnの座標系は左下の角が(0,0)だがカードは左上から埋まるようにする
  idx = (9 - idx) ^ 1

  # カードの隅の座標を計算する
  corner_y = CARD_HEIGHT * (idx/2+1) + PADDING_Y * (idx/2) + START_Y
  corner_x = CARD_WIDTH * (idx%2) + PADDING_X * (idx%2) + START_X

  # 外枠
  fill_color('ffffff')
  line_width(0.3)
  stroke_color('bbbbbb')
  rectangle([corner_x, corner_y], CARD_WIDTH, CARD_HEIGHT)
  fill_and_stroke

  # 背景画像
  image(BACK_GROUND,
        at: [corner_x, corner_y],
        width: CARD_WIDTH)

  # アイコン
  if icon
    image(icon,
          at: [corner_x + ICON_X, corner_y - ICON_Y],
          width: ICON_SIZE)
  end

  # 名前
  if id
    fill_color('000000')
    font('./font/mplus-1p-bold.ttf')
    # FIXME: 文字の大きさの設定方法は要検討
    text_box(id,
             size: id.size <= 9 ? 30 : id.size <= 11 ? 25 : 20,
             align: :center,
             width: CARD_WIDTH,
             at: [corner_x + NAME_X, corner_y - NAME_Y])
    fill_and_stroke
  end

  # 所属
  if aff
    fill_color('000000')
    font('./font/mplus-1p-regular.ttf')
    text_box(aff,
             size: 18,
             align: :center,
             width: CARD_WIDTH,
             at: [corner_x + AFFIL_X, corner_y - AFFIL_Y])
    fill_and_stroke
  end
end

rows = CSV.open('./data.csv')
# ヘッダー行をスキップ
rows.shift

Prawn::Document.generate('./namecards.pdf', page_size: 'A4', margin: [0,0,0,0]) do
  rows.each_with_index do |row, idx|
    # 名前, 所属, アイコン画像名
    id, aff, icon = row
    puts "drawing #{id} (#{aff})..."
    i = idx % 10
    if i == 0 && idx != 0
      puts 'new page'
      start_new_page
    end
    draw_card(id, aff, icon, i);
  end
end
