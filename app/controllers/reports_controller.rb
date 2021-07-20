class ReportsController < ApplicationController
  before_action :ensure_owner_logged_in, only: [:index]
  before_action :ensure_user_logged_in, only: [:invoice]

  def index
    if params[:start_date] == "" || params[:end_date] == ""
      flash[:error] = "Give The valid Date Range"
      redirect_to reports_path
    else
      if params[:end_date]
        orders = Order.where("status = ? AND delivered_at >= ? AND delivered_at <= ? ", "delivered", params[:start_date].to_date, params[:end_date].to_date + 1)
      end
      if params[:customer_id] != nil && params[:customer_id] != ""
        orders = orders.where("user_id = ? ", params[:customer_id])
      end
      render "index", locals: { orders: orders, start_date: params[:start_date], end_date: params[:end_date], customer_id: params[:customer_id] }
    end
  end

  def invoice
    order = Order.find(params[:id])
    if current_user.role == "customer"
      if current_user.orderBelongsToCurrentUser?(order) == true
        render "invoice", locals: { order: order }
      else
        flash[:error] = "Hey! You are not allowed to view other's Invoice."
        redirect_to orders_path
      end
    else
      render "invoice", locals: { order: order }
    end
  end
end
