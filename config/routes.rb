# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    root to: 'kingdoms#preload'

    get 'index', to: 'kingdoms#index'
    post 'reset_alliances', to: 'kingdoms#reset_alliances'
    post 'reset_kingdoms', to: 'kingdoms#reset_kingdoms'
    get 'begin_dialogue', to: 'kingdoms#begin_dialogue'
    get 'greeting', to: 'messages#greeting'

    resources :messages, only: :create
  end
end
