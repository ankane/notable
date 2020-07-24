Rails.application.routes.draw do
  get "error" => "home#error"
  get "slow" => "home#slow"
  get "timeout" => "home#timeout"
  post "validation" => "home#validation"
end
