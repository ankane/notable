Rails.application.routes.draw do
  get "error" => "home#error"
  get "slow" => "home#slow"
end
