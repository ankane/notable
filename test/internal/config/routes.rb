Rails.application.routes.draw do
  get "error" => "users#error"
  get "manual" => "users#manual"
  get "slow" => "users#slow"
  get "timeout" => "users#timeout"
  get "throttled" => "users#throttled"
  get "api" => "api#works"
  resources :users, only: [:create, :update]
end
