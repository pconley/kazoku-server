Rails.application.routes.draw do
  
  root to: "home#index"
  
  get 'home/index'
  get 'people/index', to: 'people#index', as: :user_root

  devise_for :users
  
  resources :people
  # add the angular 2 default style of route
  get '/people.json/:id', controller: 'people', action: :show
  
  resources :widgets
  
   devise_scope :user do 
     get "/some/route" => "some_devise_controller" 
     get 'login', controller: 'devise/sessions', action: 'create'
     get 'logout', controller: 'devise/sessions', action: 'destroy'
     
   end
  
end
