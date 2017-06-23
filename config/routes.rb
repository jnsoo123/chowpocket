Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  resources :line_items, only: [:create, :update]
  resources :orders, only: [:create, :index, :show, :destroy]
  resources :checkouts, only: :index

  get '/:name' => 'buildings#show', as: :building_path

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  root to: redirect('/JPMorgan')
end
