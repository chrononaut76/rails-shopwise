Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get 'my_items', to: 'user_items#index', as: 'my_items'
  post 'stores/list/:user_items', to: 'stores#compare_prices', as: 'list'
  post 'my_items', to: 'user_items#create'
  delete 'my_items/:id', to: 'user_items#destroy', as: 'my_item'
  get 'stores/results', to: 'stores#results'
end
