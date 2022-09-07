Rails.application.routes.draw do
  scope '/(:locale)', defaults: { locale: 'es' }, constraints: { locale: /en|es/ } do

    get 'cabinets/:id/cabinet_services' => 'cabinet_services#view'  
    get 'printers/:id/printer_services' => 'printer_services#view'

    resources :networks
    resources :printer_services
    resources :cabinet_services
    resources :schedulers
    resources :users
    resources :labels
    resources :cabinets

    resources :printers do
      resources :printer_services
    end

    resources :cabinets do
      collection do
        post 'select_multiple'
      end
      resources :cabinet_services
    end



    match "users/autenticar" => "users#autenticar", :via => :post
    match "preventive" => "cabinet_services#preventive" , :via => :get
    match "reportpdf" => "cabinet_services#reportpdf", :via => :get
    match "printerpdf" => "printers#printerpdf", :via => :get
    match "loglist" => "application#loglist", :via => :get
    match "logclear" => "application#logclear", :via => :get
    match "print" => "labels#print", :via => :post
    match "userpdf" => "users#userpdf", :via => :get
    
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'
    
    #root "cabinets#index"
    root "users#login"
    
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
end
