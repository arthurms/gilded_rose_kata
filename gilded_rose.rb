def update_quality(items)
  items.each do |item|
    refactored_items = ["NORMAL ITEM", "Aged Brie", 'Backstage passes to a TAFKAL80ETC concert', 'Conjured Mana Cake']
    if refactored_items.include? item.name
      update_item item
      next
    end

    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if !at_min_quality(item)
        if item.name != 'Sulfuras, Hand of Ragnaros'
          item.quality -= 1
        end
        if item.name == 'Conjured Mana Cake'
          item.quality -= 1
        end
      end
    else
      if !at_max_quality(item)
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if !at_max_quality(item)
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if !at_max_quality(item)
              item.quality += 1
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if !at_min_quality(item)
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.quality -= 1
            end
            if item.name == 'Conjured Mana Cake'
              item.quality -= 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if !at_max_quality(item)
          item.quality += 1
        end
      end
    end
  end
end

def update_item(item)
  case item.name
  when 'NORMAL ITEM'
    update_normal_item_quality(item) unless at_min_quality(item)
  when 'Aged Brie'
    update_aged_brie_quality(item) unless at_max_quality(item)
  when 'Backstage passes to a TAFKAL80ETC concert'
    update_backstage_pass_quality(item) unless at_max_quality(item)
  when 'Conjured Mana Cake'
    update_conjured_item_quality(item) unless at_min_quality(item)
  end

  item.sell_in -= 1
end

def update_conjured_item_quality(item)
  how_fast = 2
  how_fast = how_fast * 2 if item.sell_in <= 0
  degrade_quality(item, how_fast)
end

def update_backstage_pass_quality(item)
  how_fast = case
  when item.sell_in > 10 || (item.sell_in > 0 && item.quality == 49)
    1
  when item.sell_in > 5
    2
  when item.sell_in > 0
    3
  else
    item.quality
  end

  if item.sell_in > 0 && !at_max_quality(item)
    increase_quality(item, how_fast)
  end

  if item.sell_in <= 0
    degrade_quality(item, how_fast)
  end
end

def update_aged_brie_quality(item)
  how_fast = item.sell_in <= 0 && item.quality < 49 ? 2 : 1
  increase_quality(item, how_fast)
end

def update_normal_item_quality(item)
  how_fast = item.sell_in > 0 ? 1 : 2
  degrade_quality(item, how_fast)
end

def increase_quality(item, how_fast = 1)
  item.quality += 1 * how_fast
end

def degrade_quality(item, how_fast = 1)
  item.quality -= 1 * how_fast
end

def at_max_quality(item)
  case item.name
  when 'Sulfuras, Hand of Ragnaros'
    item.quality == 80
  else
    item.quality == 50
  end
end

def at_min_quality(item)
  case item.name
  when 'Sulfuras, Hand of Ragnaros'
    item.quality == 80
  else
    item.quality == 0
  end
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

