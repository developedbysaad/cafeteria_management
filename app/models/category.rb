class Category < ApplicationRecord
  has_many :menu_items, dependent: :delete_all
  validates :name, presence: true

  def self.displayable
    categories = Category.all.map { |category| [category.name, category.id] }
    categories.unshift(["Select Category", ""])
    return categories
  end

  def self.displayableCategoryItems
    displayableCategoryItems = {}
    categories = Category.all
    categories.each do |category|
      menu_items = category.menu_items
      menu_items = menu_items.select { |menu_item| menu_item.validate? }
      if menu_items.count > 0
        displayableCategoryItems[category.name] = menu_items
      end
    end
    return displayableCategoryItems
  end

  def menuItemsCheckedCount(menu_id)
    menu_items.where(menu_id: menu_id).where(active: true).count
  end

  def allMenuItemsCount(menu_id)
    menu_items.where(menu_id: menu_id).count
  end
end
