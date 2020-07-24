Rails.application.routes.draw do
  get "error" => "home#error"
  get "manual" => "home#manual"
  get "slow" => "home#slow"
  get "timeout" => "home#timeout"
  post "validation" => "home#validation"
end
