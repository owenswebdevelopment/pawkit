Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :families, only: ["index", "show", "create", "new", "update"] do
    resources :memories, only: ["index", "create"]
    resources :tasks, only: ["index", "create", "update"]
    resources :pets, only: ["new", "create"]
  end

  resources :location, only: ["index"]

  resources :pets, only: ["show"] do
    resources :medical_records, only: ["show", "create"]
  end

    post "join_family_action", to: "families#join_family_action", as: :join_family_action

end
