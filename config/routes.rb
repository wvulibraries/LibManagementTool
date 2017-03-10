Rails.application.routes.draw do
  # root
  root 'public#index'

  # admin
  get  '/admin', to: 'admin#index'

  get 'api/getlibs'
  get 'api/getdepts'
  get 'api/gethours'

  # forces the controllers to use the admin name space
  # this is going to allow for the addition of a function to restrict access
  # resources generates all routes for crud of libraries, departments, users, etc.
  scope '/admin' do
    resources :libraries, :departments, :users, :normal_hours, :special_hours, :user_permissions, module: 'admin'
  end

  get '/admin/departments/list', to: 'departments#index'
end
