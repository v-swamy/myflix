Myflix::Application.routes.draw do
  root to: 'pages#front'

  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'

  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'

  get "/people", to: 'relationships#index'

  get "/forgot_password", to: 'forgot_passwords#new'
  get "/forgot_password_confirmation", to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'

  resources :relationships, only: [:create, :destroy]

  resources :videos do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories
  resources :users
  resources :queue_items, only: [:create, :destroy]
  
end
