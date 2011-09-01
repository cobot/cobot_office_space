OfficeSpace::Application.routes.draw do
  root :to => 'sessions#new'

  match '/auth/:provider/callback', :to => 'sessions#create', as: :authenticate
  match '/auth/failure', :to => 'sessions#failure'

  resource :session, only: :destroy
  resources :spaces, only: [:index, :show] do
    resources :categories, only: [:new, :create, :show, :destroy] do
      resources :resources, only: [:new, :create, :show, :update, :destroy]
    end
  end
end
