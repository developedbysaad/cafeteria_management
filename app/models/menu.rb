class Menu < ApplicationRecord
  has_many :menu_items, dependent: :delete_all
  validates :name, presence: true

  def isActive?
    active
  end

  def itemsByCategory
    itemsByCategory = {}
    categories = Category.order(:id).all
    categories.map do |category|
      current_category_menu_items = menu_items.order(:id).where(category_id: category.id)
      if current_category_menu_items.count > 0
        itemsByCategory[category.id] = current_category_menu_items
      end
    end
    return itemsByCategory
  end

  def menuItemsCheckedCount
    menu_items.where(active: true).count
  end

  def self.activeMenusCount
    Menu.where(active: true).count
  end

  def self.displayable
    menus = Menu.order(:id).map { |menu| [menu.name, menu.id] }
    menus.unshift(["Select Menu", ""])
    return menus
  end
end
