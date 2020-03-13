Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  scope :api, defaults: { format: :json }  do
    devise_for :users, only: %i(registrations passwords)
    post '/authentication', to: 'authentication#create'

    resources :users, only: %i(index show)
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
