Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "home#index"

  get "/menus/changemenu" => "menus#changeMenu", as: :change_menus
  put "/menus/:id/updateMenuName" => "menus#updateMenuName"
  put "menu_items/:id/updateMenuItem" => "menu_items#updateMenuItem"

  get "/signin/new" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy"

  post "/users/:id/removeAsClerk" => "users#removeAsClerk"
  post "/users/:id/makeAsClerk" => "users#makeAsClerk"

  get "/reports/:id" => "reports#invoice", as: :invoice

  post "/orderdeliver/:id" => "orders#deliverOrder"
  post "/orders/confirm" => "orders#confirm"
  get "/orders/cart" => "orders#cart", as: :carts

  put "/order_items/:id/decrement" => "order_items#decrement"
  put "/order_items/:id/decrementInCart" => "order_items#decrementInCart"

  post "/order_items/:id/addToCart" => "order_items#addToCart"

  put "/order_items/:id/increment" => "order_items#increment"
  put "/order_items/:id/incrementInCart" => "order_items#incrementInCart"

  resources :menus
  resources :menu_items
  resources :order_items
  resources :users
  resources :applicants
  resources :categories
  resources :orders
end
