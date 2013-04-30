Belch::Application.routes.draw do
  
  #resources :messages
  get "login_callback" => "sessions#create", :as => "login_callback"
  get "logout" => "sessions#destroy", :as => "logout"
  
  get "events/join/:token" => "events#join", :as =>"join_event"
  post "events/joining" => "events#joining", :as =>"joining_event"
  resources :events, :except => :destroy do
    resources :interests
  end
  get "interest" => "interests#new", :as => "interest" #Delete later

  resources :users, :only => [:create]
  #resources :ratings do
  #  collection {post :sort}
  #end

  get "home/index"
  get "home/about"
  
  #Linkedin routes
  get "auth/index" => "auth#index"
  get "auth/callback", :as => "auth_callback"
  get "auth/linkedin", :as => "linkedin_login"
  get '/auth/:provider/callback', to: 'sessions#create'
  get "/auth/failure", to: 'home#index'
  
  #Messaging
  get "messages" => "messages#index"
  get "messages/index", :as => "messages"
  get "messages/:user_id" => "messages#show", :as => "view_messages"
  post "messages" => "messages#create", :as => "messages"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
  #       get 'recent', :on => :collection
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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
