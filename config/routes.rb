Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        resources :orders, only: [:index]
        get 'disbursed', to: 'orders#disbursed'
        get 'completed', to: 'orders#completed'
        get 'incompleted', to: 'orders#incompleted'
      end
    end
  end
end
