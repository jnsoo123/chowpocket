Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  resources :line_items, only: [:create, :update]
  resource  :line_items, only: :destroy
  resources :orders, only: [:create, :index, :show, :destroy]
  resources :checkouts, only: :index
  resource  :profiles, only: [:show, :edit, :update]
  resource  :passwords, only: [:edit, :update]

  get '/:name' => 'buildings#show', as: :building_path

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks', registrations: 'registrations' }

  root to: redirect('/JPMorgan')
end
