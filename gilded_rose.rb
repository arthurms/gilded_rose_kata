def update_quality(items)
  items.each do |item|
    if item.name == "NORMAL ITEM" || item.name == "Aged Brie"
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
  item.sell_in -= 1
  case item.name
  when 'NORMAL ITEM'
    update_normal_item_quality(item) unless at_min_quality(item)
  when 'Aged Brie'
    update_aged_brie_quality(item) unless at_max_quality(item)
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

