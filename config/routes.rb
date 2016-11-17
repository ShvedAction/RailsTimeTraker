Rails.application.routes.draw do
  resources :users
  
  post "user/log_in" => "users#log_in", as: :user_log_in, defaults: {login: nil, password: nil}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
