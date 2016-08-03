require 'stripe'
class CheckoutsController < ApplicationController

  Stripe.api_key = ENV['TEST_SECRET_KEY']

  def create

    token = params[:stripeToken]

    customer = Stripe::Customer.create(
      source: token,
      description: "This is an example customer, yo.")
    # added stripe_customer_id to user model

    # saves cc number to user object
    @user = current_user
    @user.stripe_customer_id = customer.id
    @user.save

    p @user

    # sample logic for actually charging a user

    # amount_in_cents = XXXXX
    # charge = Stripe::Charge.create(
    #   :amount => amount_in_cents, # in cents
    #   :currency => "usd",
    #   :customer => @user.stripe_customer_id
    # )

    redirect_to root_path

  end




  def show
  end

end
