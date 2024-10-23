Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "providers#index"
  
  resources :providers, only: [:index] do
    collection do
      put :find
      get :physicians
      get :clinics
    end
  end
end
