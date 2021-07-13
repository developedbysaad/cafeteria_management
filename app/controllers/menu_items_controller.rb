class MenuItemsController < ApplicationController
  before_action :ensure_owner_logged_in, only: [:edit]

  def create
    name = params[:name]
    description = params[:description]
    price = params[:price]
    menu_id = session[:current_selected_menu_id]
    category_id = params[:category_id]
    new_menu_item = MenuItem.new(name: name, description: description, price: price, menu_id: menu_id, category_id: category_id, active: false)

    if new_menu_item.valid?
      new_menu_item.save
    else
      flash[:error] = new_menu_item.errors.full_messages.join(", ")
    end
    redirect_to "/menus/#{menu_id}"
  end

  def edit
    id = params[:id]
    menu_item = MenuItem.find(id)
    categories = Category.displayable
    menus = Menu.displayable
    render "menu_item_edit", locals: { menu_item: menu_item, categories: categories, menus: menus }
  end

  def update
    id = params[:id]
    if params[:active]
      active = true
    else
      active = false
    end
    menu_item = MenuItem.find(id)
    menu_item.active = active
    menu_item.save
    if !active
      Order.deleteCurrentMenuItemCartItems(menu_item)
    end
    redirect_to "/menus/#{menu_item.menu_id}"
  end

  def updateMenuItem
    id = params[:id]
    menu_item = MenuItem.find(id)
    old_menu = Menu.find(menu_item.menu_id)
    menu_item.name = params[:name]
    menu_item.description = params[:description]
    menu_item.price = params[:price]
    menu_item.menu_id = params[:menu_id]
    menu_item.category_id = params[:category_id]
    if menu_item.valid?
      menu_item.save
      if menu_item.active && old_menu.isActive? && Menu.find(menu_item.menu_id).isActive? == false
        Order.deleteCurrentMenuItemCartItems(menu_item)
      end
      flash[:notice] = "update successfull"
      redirect_to "/menus/#{menu_item.menu_id}"
    else
      flash[:error] = menu_item.errors.full_messages.join(", ")
      redirect_to edit_menu_item_path #"menu_items/#{id}/edit"
    end
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    Order.deleteCurrentMenuItemCartItems(menu_item)
    menu_item.destroy
    redirect_to "/menus/#{session[:current_selected_menu_id]}"
  end
end
