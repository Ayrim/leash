Rails.application.routes.draw do
  
  get 'password_resets' => 'password_resets#new', :as => :new_reset_password
  get 'password_resets' => 'password_resets#edit', :as => :edit_reset_password

  root              'home#index'

  resources :users
  resources :user_sessions, only: [ :new, :create, :destroy ]
  resources :home
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :animals
  resources :dog
  resources :wallpost

  get 'login'   => 'user_sessions#new', :as => :login
  get 'logout'  => 'user_sessions#destroy', :as => :logout
  get 'signup'  => 'users#new', :as => :signup
  post 'signup' => 'users#create'
  patch 'update_profile' => 'users#update_profile', :as => :update_profile
  patch 'update_contactinfo' => 'users#update_contactinfo', :as => :update_contactinfo
  patch 'update_password' => 'users#update_password', :as => :update_password
  get 'profile' => 'users#settings', :as => :settings
  get 'edit_profile' => 'users#editSettings', :as => :edit_settings
  #post 'settings' => 'users#settings_post'
  get 'home'    => 'home#index', :as => :home_root
  get 'overview'=> 'home#overview', :as => :overview

  post 'new_dog' => 'dog#create', :as => :create_dog
  post 'new_post' => 'wallpost#create', :as => :create_wallpost
  post 'index_post' => 'wallpost#index', :as => :index_wallpost
  
  #root 'users#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
