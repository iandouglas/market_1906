class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(food_item)
    @vendors.find_all do |vendor|
      vendor.check_stock(food_item) > 0
      # alternate: vendor.inventory.key? food_item
      # alternate: vendor.inventory.keys.include? food_item
    end
  end

  def sorted_item_list
    @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten.uniq.sort
  end

  def total_inventory
    inventory = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |food, quantity|
        inventory[food] += quantity
      end
    end
    # sorted_item_list.each do |item|
    #   vendors_that_sell(item).each do |vendor|
    #     inventory[item] += vendor.check_stock(item)
    #   end
    # end
    inventory
  end

  def sell(food_item, quantity)
    if total_inventory[food_item] >= quantity
      vendors_that_sell(food_item).each do |vendor|
        if quantity == 0
          break
        end

        vendor.inventory[food_item] -= quantity
        if vendor.inventory[food_item] < 0
          quantity = vendor.inventory[food_item].abs
          vendor.inventory[food_item] = 0
        end

        # alternate
        # if quantity <= 0
        #   break
        # end

        # sub = [vendor.inventory[food_item], quantity].min
        # vendor.inventory[food_item] -= sub
        # quantity -= sub
      end
    end
  end

end
