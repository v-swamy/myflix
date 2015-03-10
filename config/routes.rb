Myflix::Application.routes.draw do
  root to: 'pages#front'

  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'

  resources :videos do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources :categories
  resources :users
end
