Rails.application.routes.draw do
  root to: 'kingdoms#index'

  post 'reset_alliances', to: 'kingdoms#reset_alliances'
  get 'begin_dialogue', to: 'kingdoms#begin_dialogue'
  get 'greeting', to: 'messages#greeting'

  resources :messages, only: :create
end
