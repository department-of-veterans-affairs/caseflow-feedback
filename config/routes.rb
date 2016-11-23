Rails.application.routes.draw do

  resource :feedback

  root 'feedback#new'

  get "unauthorized" => "application#unauthorized"
  get "health-check" => "health_checks#show"

end
