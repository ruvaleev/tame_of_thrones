Rails.application.routes.draw do
  root to: 'kingdoms#index'

  post 'reset_alliances', to: 'kingdoms#reset_alliances'
  post 'reset_kingdoms', to: 'kingdoms#reset_kingdoms'
  get 'begin_dialogue', to: 'kingdoms#begin_dialogue'
  get 'greeting', to: 'messages#greeting'

  resources :messages, only: :create
end
