require 'rails_helper'
require "bigdecimal"

RSpec.describe User, type: :model do


  context "user with orders" do
    # create 10 orders
    let(:merchant) {create(:merchant)}
    let(:shopper)  {create(:shopper)}
    let(:orders)  {create_list(:order, 10, shopper: shopper, merchant: merchant)}

    before {orders}

    it "get all the orders for the shopper" do
      expect(shopper.orders.count).to eq(10)
      # in all the orders shopper is shopper
      expect(shopper.orders.all? {|order| order.shopper == shopper}).to be_truthy
    end

    it "get all the orders for the merchant" do
      expect(merchant.orders.count).to eq(10)
      # in all the orders merchant is merchant
      expect(merchant.orders.all? {|order| order.merchant == merchant}).to be_truthy
    end

    it "gets all the completed orders" do
      # complete just the first and second orders

      orders[0].complete!
      orders[1].complete!
      # get the completed orders
      completed_orders = merchant.completed_orders
      # expect the number of completed orders to be 2
      expect(completed_orders.count).to eq(2)
      # expect the first and second orders included in the completed orders
      expect(completed_orders).to include(orders[0])
      expect(completed_orders).to include(orders[1])
    end

    it "gets all the incompleted orders" do
      # complete just the first and second orders
      orders[0].complete!
      orders[1].complete!
      # get the incompleted orders
      incompleted_orders = merchant.incompleted_orders
      # expect the number of incompleted orders to be 8
      expect(incompleted_orders.count).to eq(8)
      # expect the first and second orders not included in the incompleted orders
      expect(incompleted_orders).to_not include(orders[0])
      expect(incompleted_orders).to_not include(orders[1])
    end
  end
end
