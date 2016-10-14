Rails.application.routes.draw do
  
  resources :members
  resources :families
  root to: "home#index"
  
  get 'home/index'
  get 'people/index', to: 'people#index', as: :user_root

  devise_for :users, :skip => [:registrations]
  
  resources :people
  # add the angular 2 default style of route
  get '/people.json/:id', controller: 'people', action: :show, format: 'json'


  match '/summary.json', controller: 'summary', action: :show, format: 'json', via: [:get, :options]

  #resources :members, only: [:show], format: 'json'
  match '/members.json', controller: 'members', action: :index, format: 'json', via: [:get, :options]
  match '/members/:id.json', controller: 'members', action: :show, format: 'json', via: [:get, :options]
  
  resources :widgets
  
   devise_scope :user do 
     get 'login', controller: 'devise/sessions', action: 'create'
     get 'logout', controller: 'devise/sessions', action: 'destroy'
     
   end
  
end
