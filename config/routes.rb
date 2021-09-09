Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      get 'items/find_all', to: 'items#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, module: 'merchants', only: [:index]
      end

      resources :items, only: [:index, :show, :create, :destroy, :update] do
        resources :merchant, module: 'items', only: [:index]
      end
      scope :revenue do
        get '/merchants/:id', to: 'revenue#merchant_total_revenue'
        get '/unshipped', to: 'revenue#unshipped_orders_revenue'
      end
    end
  end
end
