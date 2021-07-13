class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  def belongToActiveMenu
    menu = Menu.getActiveMenu
    present = false
    menu.menu_items.each do |menu_item|
      if menu_item.id == id
        present = true
      end
    end
    present
  end

  def total
    quantity * menu_item_price
  end
end
