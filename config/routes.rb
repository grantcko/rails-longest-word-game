Rails.application.routes.draw do
  root 'games#new', as: :home
  get '/score', to: 'games#score', as: :score
  get '/new', to: 'games#new', as: :new
end
