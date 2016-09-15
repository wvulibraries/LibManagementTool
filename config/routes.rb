Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :libraries, path: '/admin/libraries'
  resources :departments, path: '/admin/departments'
end
