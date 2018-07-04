Rails.application.routes.draw do

  resource :users


  match '/signup', to: 'users#new', via: 'get'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
