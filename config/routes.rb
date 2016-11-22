Rails.application.routes.draw do

  resource :feedback

  root 'feedback#new'

  get "health-check", to: "health_checks#show"

end
