Rails.application.routes.draw do
  root to: 'kingdoms#index'

  post 'reset_alliances', to: 'kingdoms#reset_alliances'
end
