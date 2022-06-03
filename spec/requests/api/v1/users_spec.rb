# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  context 'Users with orders' do
    # create 10 orders for test
    let(:merchant) {create(:merchant)}
    let(:shopper)  {create(:shopper)}
    let(:orders)  {create_list(:order, 10, shopper: shopper, merchant: merchant)}

    # create other 10 orders to check that queries are getting the correct orders
    let(:merchant_2) {create(:merchant)}
    let(:shopper_2)  {create(:shopper)}
    let(:orders_2)  {create_list(:order, 10, shopper: shopper_2, merchant: merchant_2)}
    before {orders}
    before {orders_2}

    describe 'GET /index' do
      it 'gets all users' do
        get api_v1_users_path
        body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(body.count).to eq(4)
      end
    end
    describe 'GET /show' do
      it 'gets user merchant' do
        get api_v1_user_path(merchant.id)
        body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(body['id']).to eq(merchant.id)
      end
    end
    describe 'GET /orders' do
      it "gets user's orders" do
        get api_v1_user_orders_path(merchant.id)
        body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(body.count).to eq(10)
        expect(body.all? {|order| order['merchant_id'] == merchant.id}).to be_truthy
      end
    end
    describe 'GET /completed' do
      it "gets user's completed orders" do
         # complete just the first and second orders
        orders[0].complete!
        orders[1].complete!

        # get the completed orders
        get api_v1_user_completed_path(merchant.id)
        body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(body.count).to eq(2)
        expect(body.all? {|order| order['merchant_id'] == merchant.id}).to be_truthy
        expect(body.all? {|order| !order['completed_at'].nil?}).to be_truthy
        expect(body.pluck('id')).to include(orders[0].id)
        expect(body.pluck('id')).to include(orders[1].id)
      end
    end
    describe 'GET /incompleted' do
      it "gets user's incompleted orders" do
        # complete just the first and second orders
        orders[0].complete!
        orders[1].complete!

        # get the incompleted orders
        get api_v1_user_incompleted_path(merchant.id)
        body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(body.count).to eq(8)
        expect(body.all? {|order| order['merchant_id'] == merchant.id}).to be_truthy
        expect(body.all? {|order| order['completed_at'].nil?}).to be_truthy
        expect(body.pluck('id')).to_not include(orders[0].id)
        expect(body.pluck('id')).to_not include(orders[1].id)
        expect(body.pluck('id')).to include(orders[2].id)
      end
    end

    describe 'GET /disbursed' do
      # set the dates to a week ago
      let(:begin_date_past_week) {Date.today - Date.today.wday - 6}
      let(:end_date_past_week) {Date.today - Date.today.wday}

      # set the dates to a week in the present to contrast results
      let(:begin_date_current_week) {Date.today - Date.today.wday + 1}
      let(:end_date_current_week) {Date.today - Date.today.wday + 7}

      # create 10 orders for the past week and 10 orders for the current week
      let(:number_of_orders) {10}
      let(:completed_orders_past_week)  {create_list(:order, number_of_orders, shopper: shopper, merchant: merchant, amount: 100.0)}
      let(:completed_orders_current_week)  {create_list(:order, number_of_orders, shopper: shopper, merchant: merchant, amount: 1000.0)}
      before {
        completed_orders_past_week
        completed_orders_current_week
      }

      it "gets user's disbursed amount for a week for a given date" do
        # completed orders for past week
        completed_orders_past_week.each do |order|
          order.update(completed_at: Faker::Date.between(from: begin_date_past_week, to: end_date_past_week))
        end
        # Complet orders for current week
        completed_orders_current_week.each do |order|
          order.update(completed_at: Faker::Date.between(from: begin_date_current_week, to: end_date_current_week))
        end

        # get target date for past week
        target_date = Faker::Date.between(from: begin_date_past_week, to: end_date_past_week)

        # get disbursed amount for past week
        get api_v1_user_disbursed_path(merchant.id, params: {date: target_date}) #(params: {id: merchant.id, date: target_date})
        body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(body['amount']).to eq((BigDecimal('99.05')*BigDecimal(number_of_orders)).to_f)
        expect(Date.parse(body['begin_date'])).to eq(begin_date_past_week)
        expect(Date.parse(body['end_date'])).to eq(end_date_past_week)
      end
    end
  end
end
