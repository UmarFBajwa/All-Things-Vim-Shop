require 'stripe'

class CheckoutsController < ApplicationController

  Stripe.api_key = ENV['TEST_SECRET_KEY']

  def create

    token = params[:stripeToken]
    p token
    customer = Stripe::Customer.create(
      source: token,
      description: "This is an example customer, yo.")
    # added stripe_customer_id to user model
    p customer
    # saves cc number to user object

    current_user.stripe_customer_id = customer.id
    current_user.save


    # sample logic for actually charging a user

    # amount_in_cents = XXXXX
    # charge = Stripe::Charge.create(
    #   :amount => amount_in_cents, # in cents
    #   :currency => "usd",
    #   :customer => @user.stripe_customer_id
    # )

    redirect_to '/checkouts/confirm'

  end

  def confirm
    @order = current_user.orders.where(checked_out: false).first
    @user = current_user
    # @customer_id = @user.stripe_customer_id

    render '/checkouts/confirm'
  end



  def show
  end

end
