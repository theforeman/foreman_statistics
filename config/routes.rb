Rails.application.routes.draw do
  get 'new_action', to: 'foreman_statistics/hosts#new_action'
  get 'foreman_statistics', to: 'foreman_statistics/react#index'
end
