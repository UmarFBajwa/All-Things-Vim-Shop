class OrderedItemsController < ApplicationController
  def create
    if current_user.orders.empty? || current_user.orders.last.checked_out
      order = Order.create(user_id: current_user.id)
    else
      order = current_user.orders.last
    end
    basket_item = OrderedItem.new(ordered_item_params)
    basket_item.order_id = order.id
    basket_item.save
    if request.xhr?
      render :create, layout: false
    else
      flash[:success] = 'You successfully added that item to the cart.'
      redirect_to root_path
    end
  end

  def update
    ordered_item = OrderedItem.find(params[:ordered_item][:id])
    ordered_item.update(ordered_item_params)
    redirect_to my_cart_path
  end

  def destroy
    ordered_item = OrderedItem.find(params[:ordered_item][:id])
    ordered_item.delete
    redirect_to my_cart_path
  end


  private
  def ordered_item_params
    params.require(:ordered_item).permit(:order_id, :item_id, :order_quantity, :id)
  end
end
