module Api
  module V1
    class OrdersController < ActionController::Base
      def index
        render json: User.find(order_params).orders
      end

      def completed
        render json: User.find(order_params).completed_orders
      end

      def incompleted
        render json: User.find(order_params).incompleted_orders
      end

      def disbursed
        # validate if date is present
        if params[:date].nil?
          render json: { error: "Date is required" }, status: :unprocessable_entity
          return
        end

        # validate date format
        begin
          Date.parse(params[:date])
        rescue error
          render json: { error: "Date is invalid" }, status: :unprocessable_entity
          return
        end

        date = Date.parse(params[:date])
        orders = User.find(order_params).completed_orders.filter_by_week(date)
        Order.disbursed_amount(orders)
        render json: Order.disbursed_amount(orders)
      end

      def order_params
        params.require(:user_id)
      end
    end
  end
end
