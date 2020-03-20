Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  scope :api, defaults: { format: :json }  do
    devise_for :users, only: %i(registrations passwords)
    post '/authentication', to: 'authentication#create'

    resources :users, only: %i(index show)
    resources :clubs, only: %i(index show create) do
      namespace :clubs, path: "" do
        resources :events, only: %i(index show create)
        resources :groups, only: %i(create update)
        resources :members, only: %i(create) do
          post :approve
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
