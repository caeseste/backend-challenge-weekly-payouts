module Api
  module V1
    class UsersController < ActionController::Base
      def index
        render json: User.all, except: [:password_digest]
      end

      def show
        render json: User.find(params[:id]), except: [:password_digest]
      end
    end
  end
end
