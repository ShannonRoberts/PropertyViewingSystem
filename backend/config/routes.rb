Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :properties do
        resources :viewings, except: [:index]
        resources :availability_slots, except: [:index]
      end
      resources :viewings, only: [:index, :update, :destroy, :create]
      resources :availability_slots, only: [:show, :update, :destroy, :create, :index]
      resources :potential_tenants
      resources :property_managers
    end
  end

  # Health check endpoint
  get '/health', to: 'application#health'

  # Serve React app at root
  root 'application#fallback_index_html'

end
