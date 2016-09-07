Rails.application.routes.draw do
  
  resources :families
  root to: "home#index"
  
  get 'home/index'
  get 'people/index', to: 'people#index', as: :user_root

  devise_for :users, :skip => [:registrations]
  
  resources :people
  # add the angular 2 default style of route
  get '/people.json/:id', controller: 'people', action: :show, format: 'json'
  
  get '/members.json/', controller: 'members', action: :index, format: 'json'
  
  resources :widgets
  
   devise_scope :user do 
     get 'login', controller: 'devise/sessions', action: 'create'
     get 'logout', controller: 'devise/sessions', action: 'destroy'
     
   end
  
end
