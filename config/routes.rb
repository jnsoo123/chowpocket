Rails.application.routes.draw do
  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.is_admin?
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => '/resque_web'
  end

  ActiveAdmin.routes(self)

  resources :line_items, only: [:create, :update]
  resources :orders, only: [:create, :index, :show, :destroy]
  resources :checkouts, only: :index
  resources :buildings, only: [:index, :show]

  resource  :line_items, only: :destroy
  resource  :profiles, only: [:show, :edit, :update]
  resource  :passwords, only: [:edit, :update]

  get '/privacy', to: 'footer#privacy'
  get '/faqs', to: 'footer#faqs'

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks', registrations: 'registrations' }

  root to: redirect('/buildings/1')
end
