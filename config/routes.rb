Rails.application.routes.draw do
  scope :api, defaults: { format: :json }  do
    post '/authentication', to: 'authentication#create'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
