Rails.application.routes.draw do
  # root
  root 'public#index'

  # admin
  get  '/admin', to: 'admin#index'
  get  '/admin/logout', to: 'admin#logout'

  get 'api/libs'
  get 'api/depts'
  get 'api/deptsbylib'
  get 'api/hours'

  # get 'api/:month/gethours' => 'api#gethours'
  # get 'api/:day/gethours' => 'api#gethours'
  # get 'api/:week/gethours' => 'api#gethours'
  # get 'api/:lib/gethours' => 'api#gethours'
  # get 'api/:dept/gethours' => 'api#gethours'

  get 'rss', to: 'feeds#index', format: 'rss'
  get 'feed.rss', to: 'feeds#rss', format: 'rss'
  get 'feed', to: 'feeds#rss', format: 'rss'

  # forces the controllers to use the admin name space
  # this is going to allow for the addition of a function to restrict access
  # resources generates all routes for crud of libraries, departments, users, etc.
  scope '/admin' do
    resources :libraries, :departments, :users, :normal_hours, :special_hours, :user_permissions, module: 'admin'
  end

  get '/hours', to: 'public/hours#index'
  get '/admin/departments/list', to: 'departments#index'
end
