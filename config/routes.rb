Rails.application.routes.draw do

  resources :users do
    resources :tracks, except: :create
  end
  resources :tracks, only: :create
  
  post "user/log_in" => "users#log_in", as: :user_log_in, defaults: {login: nil, password: nil}
end
