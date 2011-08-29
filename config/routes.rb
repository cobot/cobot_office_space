OfficeSpace::Application.routes.draw do
  root :to => 'sessions#new'

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  resources :spaces, only: [:index, :show] do
    resources :categories, only: [:new, :create]
  end
end
