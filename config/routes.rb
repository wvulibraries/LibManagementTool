Rails.application.routes.draw do

  # admin
  get     '/admin', to: 'admin#index'

  # forces the controllers to use the admin name space
  # this is going to allow for the addition of a function to restrict access
  # resources generates all routes for crud of libraries, departments, users, etc.

  scope '/admin' do
    resources :libraries, :departments, :users, module: 'admin'
  end

  # login
  get     '/login',   to: 'sesions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # root
  root 'public#index'

end
