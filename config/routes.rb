Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/:name' => 'buildings#show', as: :building_path

  devise_for :users
  root to: redirect('/JPMorgan')
end
