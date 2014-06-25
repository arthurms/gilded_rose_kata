def update_quality(items)
  items.each do |item|
    update_item item
  end
end

def update_item(item)
  case item.name
  when 'NORMAL ITEM'
    update_normal_item_quality(item)
  when 'Aged Brie'
    update_aged_brie_quality(item)
  when 'Backstage passes to a TAFKAL80ETC concert'
    update_backstage_pass_quality(item)
  when 'Conjured Mana Cake'
    update_conjured_item_quality(item)
  end

  item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
end

def update_conjured_item_quality(item)
  how_fast = item.sell_in > 0 ? 2 : 4
  degrade_quality(item, how_fast)
end

def update_backstage_pass_quality(item)
  how_fast = case
  when item.sell_in > 10
    1
  when item.sell_in > 5
    2
  when item.sell_in > 0
    3
  else
    item.quality
  end

  if item.sell_in > 0
    increase_quality(item, how_fast)
  end

  if item.sell_in <= 0
    degrade_quality(item, how_fast)
  end
end

def update_aged_brie_quality(item)
  how_fast = item.sell_in <= 0 ? 2 : 1
  increase_quality(item, how_fast)
end

def update_normal_item_quality(item)
  how_fast = item.sell_in > 0 ? 1 : 2
  degrade_quality(item, how_fast)
end

def increase_quality(item, how_fast = 1)
  item.quality += 1 * how_fast
  item.quality = 50 if item.quality > 50
end

def degrade_quality(item, how_fast = 1)
  item.quality -= 1 * how_fast
  item.quality = 0 if item.quality < 0
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

