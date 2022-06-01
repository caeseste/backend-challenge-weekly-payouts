require 'rails_helper'

RSpec.describe User, type: :model do

  describe "orders" do
    it "merchant completed orders must be disbursed with 0.95% of fee" do
      # create random shoppers and merchants
      shopper = create(:shopper)
      merchant = create(:merchant)
      number_of_orders = 27

      orders = create_list(:order, number_of_orders, shopper: shopper, merchant: merchant)
      orders.each do |order|
        order.complete!
      end

      disbursed = Order.disbursed_amount orders
      expect(orders).to eq(merchant.completed_orders)
      expect(disbursed).to eq((99.05*number_of_orders).round(2))
    end
  end

end
