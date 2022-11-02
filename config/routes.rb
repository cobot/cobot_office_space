OfficeSpace::Application.routes.draw do
  root to: 'welcome#show'

  get '/auth/:provider/callback', to: 'sessions#create', as: :authenticate
  get '/auth/failure', to: 'sessions#failure'

  resource :session, only: %i[new destroy]
  resources :spaces, only: %i[index show] do
    resources :categories, only: %i[new create show destroy] do
      resources :resources, only: %i[new create show update destroy]
    end
  end
end
