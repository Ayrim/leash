Rails.application.routes.draw do

  get 'user_relation/show'

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
  resources :messaging
  resources :images
  resources :picture
  resources :user_relation

  namespace :api do
    scope module: :v1 do
      # User_Session
      post 'signin' => 'user_sessions#sign_in'
      post 'signout' => 'user_sessions#sign_in'

      # Users
      get 'users' => 'users#index'
      get 'users/:id' => 'users#get_user'

      # Address
      get 'address' => 'address#get_addresses'
      get 'address/:id' => 'address#get_address'
      post 'address' => 'address#create_address'

      get 'city' => 'address#get_cities'
      get 'city/:id' => 'address#get_city'
      post 'city' => 'address#create_city'

      get 'country' => 'address#get_countries'
      get 'country/:id' => 'address#get_country'
      post 'country' => 'address#create_country'
    end
  end

  # Users
  get 'login'   => 'user_sessions#new', :as => :login
  get 'logout'  => 'user_sessions#destroy', :as => :logout
  get 'signup'  => 'users#new', :as => :signup
  post 'signup' => 'users#create'
  patch 'update_profile' => 'users#update_profile', :as => :update_profile
  patch 'update_walker_profile' => 'users#update_walker_profile', :as => :update_walker_profile
  patch 'update_contactinfo' => 'users#update_contactinfo', :as => :update_contactinfo
  patch 'update_password' => 'users#update_password', :as => :update_password
  get 'profile' => 'users#show', :as => :settings
  get 'edit_profile' => 'users#editSettings', :as => :edit_settings
  get 'send_invitation/:id' => 'users#send_invitation', :as => :send_invitation
  #post 'settings' => 'users#settings_post'

  # Home
  get 'home'    => 'home#index', :as => :home_root
  get 'overview'=> 'home#overview', :as => :overview

  # Messages
  get 'messaging' => 'messaging#index', :as => :root_messaging
  get 'update_unreadmessages' => 'messaging#update_unreadMessages', :as => :update_unreadmessages
  post 'new_message' => 'messaging#create_message', :as => :create_message

  # Relations
  get 'remove_connection/:id' => 'user_relation#remove_connection', :as => :remove_connection
  get 'accept_invitation/:id' => 'user_relation#accept_invitation', :as => :accept_invitation

  # Photo albums
  post 'create_picture' => 'picture#create', :as => :create_picture
  post 'create_photoalbum' => 'images#create_photoalbum', :as => :create_photoalbum
  patch 'edit_photoalbum' => 'images#edit_photoalbum', :as => :edit_photoalbum
  patch 'edit_picture' => 'picture#edit_picture', :as => :update_picture

  # Dogs
  post 'new_dog' => 'dog#create', :as => :create_dog


  # Wallposts
  post 'new_post' => 'wallpost#create', :as => :create_wallpost
  post 'index_post' => 'wallpost#index', :as => :index_wallpost
  get 'extendPosts' => 'wallpost#showNewPosts', :as => :extend_wallpost
  get 'extendPostsAfterDelete/:id' => 'wallpost#showNewPosts', :as => :extendAfterDelete_wallpost

  # Tags
  post 'new_tag' => 'tag#create', :as => :create_tag

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
