Rails.application.routes.draw do
  
  resources :members
  resources :families

  root to: "home#index"
  get 'home/index', to: 'home#index'
  
  # go to this action/page after the devise login
  get 'members', to: 'members#index', as: :user_root

  devise_for :users, :skip => [:registrations]
    
  devise_scope :user do 
     get 'login', controller: 'devise/sessions', action: 'create'
     get 'logout', controller: 'devise/sessions', action: 'destroy'
  end

  namespace :api do
    namespace :v1 do
        match '/summary', controller: 'summary', action: :show, via: [:get, :options]

        match '/events', controller: 'events', action: :index, via: [:get, :options]
        match '/events/:id', controller: 'events', action: :show, via: [:get, :options]

        match '/members', controller: 'members', action: :index,  via: [:get, :options]
        match '/members/:id', controller: 'members', action: :show, via: [:get, :options]
    end
  end
  
end
