Rails.application.routes.draw do
  get 'sessions/create'

  get '/auth/github/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/dashboard', to: 'dashboard#show'

  root 'welcome#show'
end
