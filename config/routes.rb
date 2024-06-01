Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :my_items, controller: 'user_items', only: %i[index destroy] do
    collection do
      get 'recipes'
    end
  end
  post 'my_items(/:item_id)', to: 'user_items#create'
  delete 'my_items/:id', to: 'user_items#destroy'
  get 'stores/results', to: 'stores#results'
end
