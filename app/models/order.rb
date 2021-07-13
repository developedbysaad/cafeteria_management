class Order < ApplicationRecord
  has_many :order_items, dependent: :delete_all
  belongs_to :user

  def isValid?
    order = Order.find(id)
    if order.price > 0
      valid = true
    else
      valid = false
    end
  end

  def self.pendingOrders
    all.where(status: "notdelivered").order(id: :asc)
  end

  def self.deliveredOrders
    all.where(status: "delivered").order(id: :asc)
  end

  def totalPrice
    total_price = 0
    order_items.each do |order_item|
      total_price += order_item.total
    end
    total_price
  end

  def self.totalOrdersPrice
    total_price = 0
    all.each do |order|
      total_price += order.price
    end
    total_price
  end
  def self.deleteCurrentMenuCartItems(menu)
    orders = where(status: "notprocessed")
    if orders
      orders.each do |order|
        if order.order_items
          order.order_items.each do |order_item|
            if order_item.menu_item.menu.id == menu.id
              order_item.destroy
            end
          end
        end
      end
    end
  end

  def self.deleteCurrentMenuItemCartItems(menu_item)
    orders = where(status: "notprocessed")
    if orders
      orders.each do |order|
        if order.order_items
          order.order_items.each do |order_item|
            if order_item.menu_item_id == menu_item.id
              order_item.destroy
            end
          end
        end
      end
    end
  end

  def self.deleteCurrentCategoryCartItems(category)
    orders = where(status: "notprocessed")
    if orders
      orders.each do |order|
        if order.order_items
          order.order_items.each do |order_item|
            menu_item = MenuItem.find(order_item.menu_item_id)
            if category.menu_items.include?(menu_item)
              order_item.destroy
            end
          end
        end
      end
    end
  end
end
