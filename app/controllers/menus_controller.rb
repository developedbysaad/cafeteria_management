class MenusController < ApplicationController
  before_action :ensure_user_logged_in, only: [:index]
  before_action :ensure_owner_logged_in, only: [:show, :changeMenu]

  def index
    if session[:current_order_id] == nil
      orders = Order.where(user_id: current_user.id)
      if orders
        previous_order = orders.find_by(status: "notprocessed")
        if previous_order
          session[:current_order_id] = previous_order.id
        end
      end
      if session[:current_order_id] == nil
        user_id = current_user.id
        order = Order.create!(user_id: user_id, date: DateTime.now, delivered_at: nil, status: "notprocessed", price: 0)
        session[:current_order_id] = order.id
      end
    end
    displayableCategoryItems = Category.displayableCategoryItems
    render "index", locals: { displayableCategoryItems: displayableCategoryItems }
  end

  def create
    name = params[:name]
    menu = Menu.new(name: name, active: false)
    if menu.valid?
      menu.save
    else
      flash[:error] = menu.errors.full_messages.join(", ")
    end
    redirect_to change_menus_path
  end

  def show
    id = params[:id]
    session[:current_selected_menu_id] = id
    menu = Menu.find(id)
    categories = Category.displayable
    render "display_menu", locals: { menu: menu, categories: categories }
  end

  def edit
    id = params[:id]
    menu = Menu.find(id)
    render "menu_edit", locals: { menu: menu }
  end

  def update
    id = params[:id]
    if params[:active]
      active = true
    else
      active = false
    end
    menu = Menu.find(id)
    menu.active = active
    menu.save
    if !active
      Order.deleteCurrentMenuCartItems(menu)
    end
    redirect_to change_menus_path
  end

  def updateMenuName
    id = params[:id]
    menu = Menu.find(id)
    menu.name = params[:name]
    if menu.valid?
      menu.save
      flash[:notice] = "Update Successful"
      redirect_to change_menus_path
    else
      flash[:error] = menu.errors.full_messages.join(", ")
      redirect_to edit_menu_path
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    Order.deleteCurrentMenuCartItems(menu)
    menu.destroy
    redirect_to change_menus_path
  end

  def changeMenu
    render "activeMenus"
  end
end
