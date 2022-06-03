require 'rails_helper'

RSpec.describe Order, type: :model do

    it "should set completed_at when order is completed" do
      shopper = create(:shopper)
      merchant = create(:merchant)
      order = create(:order, shopper: shopper, merchant: merchant)
      order.complete!
      expect(order.completed_at).to_not be_nil
    end

    context "Orders completed with different date" do
      let(:merchant) {create(:merchant)}
      let(:shopper)  {create(:shopper)}

       # set the dates to a week ago
      let(:begin_date_past_week) {Date.today - Date.today.wday - 6}
      let(:end_date_past_week) {Date.today - Date.today.wday}

      # set the dates to a week in the present to contrast results
      let(:begin_date_current_week) {Date.today - Date.today.wday + 1}
      let(:end_date_current_week) {Date.today - Date.today.wday + 7}

      # create 10 orders for the past week and 10 orders for the current week
      let(:number_of_orders) {10}
      let(:completed_orders_past_week)  {create_list(:order, number_of_orders, shopper: shopper, merchant: merchant)}
      let(:completed_orders_current_week)  {create_list(:order, number_of_orders, shopper: shopper, merchant: merchant)}
      before {
        completed_orders_past_week
        completed_orders_current_week
      }

      it "should get all orders completed for a week for a given date" do
        # Complet orders for past week
        completed_orders_past_week.each do |order|
          order.update(completed_at: Faker::Date.between(from: begin_date_past_week, to: end_date_past_week))
        end
        # Complet orders for current week
        completed_orders_current_week.each do |order|
          order.update(completed_at: Faker::Date.between(from: begin_date_current_week, to: end_date_current_week))
        end
        # Get orders completed for past week
        target_date = Faker::Date.between(from: begin_date_past_week, to: end_date_past_week)
        expect(Order.filter_by_week(target_date)).to eq(completed_orders_past_week)
        expect(Order.filter_by_week(target_date)).to_not include(completed_orders_current_week)
        expect(Order.filter_by_week(target_date).count).to eq(number_of_orders)
      end
    end

    context "Orders with different amount" do
      let(:merchant) {create(:merchant)}
      let(:shopper)  {create(:shopper)}
      let(:order_10) {create(:order, shopper: shopper, merchant: merchant, amount: 10.0)}
      let(:order_100) {create(:order, shopper: shopper, merchant: merchant, amount: 100.0)}
      let(:order_1000) {create(:order, shopper: shopper, merchant: merchant, amount: 1000.0)}
      it "disbursed amount should be 99% for an order with amount less than 50" do
        expect(order_10.disbursed_amount).to eq(9.9)
      end
      it "disbursed amount should be 99.05% for an order with amounts between 50 - 300" do
        expect(order_100.disbursed_amount).to eq(99.05)
      end

      it "disbursed amount should be 99.15% for an order with amounts over 300" do
        expect(order_1000.disbursed_amount).to eq(991.5)
      end
    end

    describe "merchant orders completed" do
      it "must be disbursed with 0.95% of fee" do

        shopper = create(:shopper)
        merchant = create(:merchant)
        number_of_orders = 87
        # create orders with amount of 100 (between 50 - 300 for a fee of 0.95%)
        orders = create_list(:order, number_of_orders, shopper: shopper, merchant: merchant, amount: 100.0)
        # complete orders
        orders.each { |order| order.complete! }

        # get disbursed amount for merchant
        disbursed = Order.disbursed_amount orders
        expect(orders.sort_by(&:completed_at)).to eq(merchant.completed_orders.sort_by(&:completed_at))
        expect(disbursed).to eq((BigDecimal('99.05')*BigDecimal(number_of_orders)).to_f)
      end
    end

end
