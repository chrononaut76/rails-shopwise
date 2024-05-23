Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # get 'my_items', to: 'user_items#index', as: 'my_items'
  # post 'my_items/(:item_id)', to: 'user_items#create'
  # delete 'my_items/:id', to: 'user_items#destroy', as: 'my_item'

  resources :my_items, controller: 'user_items', only: %i[index destroy]
  post 'my_items(/:item_id)', to: 'user_items#create'
  get 'stores/results', to: 'stores#results'
end
