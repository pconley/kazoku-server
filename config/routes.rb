Rails.application.routes.draw do
  
  resources :members
  resources :families
  root to: "home#index"
  
  get 'home/index'
  get 'members/index', to: 'members#index', as: :user_root

  devise_for :users, :skip => [:registrations]
  
  #resources :people
  # add the angular 2 default style of route
  #get '/people.json/:id', controller: 'people', action: :show, format: 'json'


  #resources :members, only: [:show], format: 'json'
  #match '/members.json', controller: 'members', action: :index, format: 'json', via: [:get, :options]
  #match '/members/:id.json', controller: 'members', action: :show, format: 'json', via: [:get, :options]
  #resources :widgets
  
  devise_scope :user do 
     get 'login', controller: 'devise/sessions', action: 'create'
     get 'logout', controller: 'devise/sessions', action: 'destroy'
  end

  scope :format => true, :constraints => { :format => 'json' } do
    namespace :api do
      namespace :v1 do
        match '/summary', controller: 'summary', action: :show, format: 'json', via: [:get, :options]
        match '/members', controller: 'members', action: :index, format: 'json', via: [:get, :options]
        match '/members/:id', controller: 'members', action: :show, format: 'json', via: [:get, :options]

       end
    end
  end
  
end
