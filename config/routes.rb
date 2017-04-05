Rails.application.routes.draw do
  # root
  root 'public#index'

  # admin
  get  '/admin', to: 'admin#index'

  get 'api/getlibs'
  get 'api/getdepts'
  get 'api/getdeptsbylib'
  get 'api/gethours'

  # get 'api/:month/gethours' => 'api#gethours'
  # get 'api/:day/gethours' => 'api#gethours'
  # get 'api/:week/gethours' => 'api#gethours'
  # get 'api/:lib/gethours' => 'api#gethours'
  # get 'api/:dept/gethours' => 'api#gethours'

  # forces the controllers to use the admin name space
  # this is going to allow for the addition of a function to restrict access
  # resources generates all routes for crud of libraries, departments, users, etc.
  scope '/admin' do
    resources :libraries, :departments, :users, :normal_hours, :special_hours, :user_permissions, module: 'admin'
  end

  scope '/' do
    resources :hours, module: 'public'
  end

  get '/admin/departments/list', to: 'departments#index'
end
