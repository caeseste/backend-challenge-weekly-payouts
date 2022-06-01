require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "callbacks" do
    it "should set completed_at when order is completed" do
      shopper = create(:shopper)
      merchant = create(:merchant)
      order = create(:order, shopper: shopper, merchant: merchant)
      order.complete!
      expect(order.completed_at).to_not be_nil
    end
  end
end
