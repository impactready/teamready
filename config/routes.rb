Incivent_App::Application.routes.draw do

  namespace :admin do
    resources :accounts
    resources :users, only: :destroy
  end

  resources :subscriptions do
    collection do
      # get 'paypal_checkout'
      # get 'finalise'
      post 'activate'
    end
  end

  resources :password_resets

  resources :priorities
  resources :types
  resources :statuses
  resources :indicators
  resources :incivents  do
    collection do
      get 'sort_index'
    end
  end

  resources :messages do
    collection do
      get 'sort_index'
    end
  end

  resources :tasks do
    collection do
      get 'sort_index'
      get 'dynamic_users'
    end
  end

  resources :users, only: [:new, :edit, :index, :create, :update, :destroy] do
    resources :admin_groups, only: :index
    # /users/:user_id/admin_groups/
  end

  resources :use_sessions, only: [:new, :create, :destroy]
  resources :groups, only: [:new, :edit, :index, :create, :update, :destroy]
  resources :memberships, only: [:create, :destroy]

  resources :accounts
  resources :account_options, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :invitations, only: [:new, :create]
  resources :launch_interests, only: [:index, :create, :destroy]

  get '/sms_ios/receive', to: 'sms_ios#receive', defaults:  {format: :json}
  get '/register', to: 'accounts#new'
  get '/signup/:invitation_token', to: 'users#new'
  get '/signup', to: 'users#new'
  get '/signin', to: 'use_sessions#new'
  delete '/signout', to: 'use_sessions#destroy'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#service_terms'
  get '/pricing', to: 'static_pages#pricing_signup'
  get '/contact', to: 'static_pages#contact'

  root to: 'static_pages#home'

end
