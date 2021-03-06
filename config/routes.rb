# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    root to: 'game_sets#preload'

    get 'index', to: 'game_sets#index'
    post 'reset_player', to: 'game_sets#reset_player'

    post 'update', to: 'kingdoms#update'
    post 'reset_alliances', to: 'kingdoms#reset_alliances'
    post 'reset_kingdoms', to: 'kingdoms#reset_kingdoms'

    get 'greeting', to: 'messages#greeting'
    resources :messages, only: :create
  end
end
