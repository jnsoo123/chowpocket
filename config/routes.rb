Rails.application.routes.draw do
  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.is_admin?
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => '/resque_web'
  end

  ActiveAdmin.routes(self)

  mount Facebook::Messenger::Server, at: 'bot'

  resources :line_items, only: [:create, :update]
  resources :orders, only: [:create, :index, :show, :destroy]
  resources :checkouts, only: :index
  resources :buildings, only: :index
  resources :landing_page, only: :index
  resources :notifications, only: [:index, :destroy]

  resource  :line_items, only: :destroy
  resource  :profiles, only: [:show, :edit, :update]
  resource  :passwords, only: [:edit, :update]

  get '/privacy', to: 'footer#privacy'
  get '/faqs', to: 'footer#faqs'
  get '/contact_us', to: 'footer#contact_us'
  get '/terms_of_use', to: 'footer#terms_of_use'
  get '/sms_terms_of_use', to: 'footer#sms_terms_of_use'
  get '/chowpartner_faqs', to: 'footer#chowpartner_faqs'
  get '/profiles/verify', to: 'profiles#verify'

  delete '/clear_notifications', to: 'notifications#destroy_all', as: :clear_notifications

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks', registrations: 'registrations' }
  root to: 'landing_page#index'
end
