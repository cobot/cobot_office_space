OfficeSpace::Application.routes.draw do
  root :to => 'sessions#new'

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  resource :session, only: :destroy
  resources :spaces, only: [:index, :show] do
    resources :categories, only: [:new, :create, :show] do
      resources :resources, only: [:show, :update]
    end
  end
end
