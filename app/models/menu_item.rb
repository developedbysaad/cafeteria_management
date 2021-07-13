class MenuItem < ApplicationRecord
  belongs_to :menu
  validates :name, presence: true
  validates :price, presence: true
  validates :category_id, presence: true

  def category
    id = category_id
    category = Category.find(id)
    category.name
  end

  def menu_name
    id = menu_id
    menu = Menu.find(id)
    menu.name
  end

  def validate?
    menu = Menu.find(menu_id)
    puts "name is #{name} active is#{active} menu.active is #{menu.active}"
    if active && menu.active
      return true
    else
      return false
    end
  end

  def self.activeMenuItemsCount
    list = where(active: true).select do |menu_item|
      menu_id = menu_item.menu_id
      menu = Menu.find(menu_id)
      menu.isActive?
    end
    list.count
  end
end
