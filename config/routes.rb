Rails.application.routes.draw do
  get 'pages/main'
  get 'status' => 'pages#status', as: :status
  root 'pages#main'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :links do
    collection do
      delete 'clear_all'
    end
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  offline = Rack::Offline.configure :cache_interval => 1200 do
    cache "404.html"
    cache "500.html"
    action_view = ActionView::Base.new
    action_view.stylesheet_link_tag("application").split("\n").collect{|a|          cache a.match(/href=\"(.*)\"/)[1] }
    action_view.javascript_include_tag("application").split("\n").collect{|a|       cache a.match(/src=\"(.*)\"/)[1] }

    network

    fallback
  end
  get "/manifest.appcache" => offline
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
