Incivent_App::Application.routes.draw do

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

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(id: product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root to: 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
