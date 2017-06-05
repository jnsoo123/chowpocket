Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  mount Facebook::Messenger::Server, at: 'bot'
  root to: 'home#index'
end
