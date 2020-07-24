Rails.application.routes.draw do
  get "error" => "users#error"
  get "manual" => "users#manual"
  get "slow" => "users#slow"
  get "timeout" => "users#timeout"
  resources :users, only: [:create]
end
