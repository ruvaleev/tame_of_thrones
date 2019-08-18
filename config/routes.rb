Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'reset_alliances', to: 'kingdoms#reset_alliances'
end
