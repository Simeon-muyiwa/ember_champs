Rails.application.routes.draw do

  

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'account_activations/edit'

  resources :sessions
  resources :users do
    member do
      get :following, :followers
   end 
 end

 

  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts,                only: [:create, :destroy]
  resources :relationships,        only: [:create, :destroy]
  resources :diets, only: [:new, :create, :show]
  resources :ingredients, only: [:new, :create, :show]


  resources :recipes do
    member do
      post 'like'
    end
  end


  add_relationship_links = Proc.new do
    collection do
      get :index
      put :update
    end
    member do
      post :create
      get :show
      delete :destroy
    end
  end


  #api
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy] do
        namespace :links do
          resources :followers, only: [] do
            add_relationship_links.call
          end
          resources :following, only: [] do
            add_relationship_links.call
          end
        end
      end
      resources :posts, only: [:index, :create, :show, :update, :destroy]
      resources :sessions, only: [:create]
    end
  end
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  
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
