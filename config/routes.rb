Rails.application.routes.draw do
  mount Facebook::Messenger::Server, at: 'bot'
  root to: 'home#index'
end
