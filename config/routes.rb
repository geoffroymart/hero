Rails.application.routes.draw do
  devise_for :users,
              controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'my_devise/registrations'}

  root to: 'pages#home'
  get '/about', to: 'pages#about'

  resources :requests do
    member do
      get 'confirmation'
      post 'disable'
      put 'decline', to: 'requests#decline'
      put 'done', to: 'requests#done'
      put 'note', to: 'requests#personal_note'
      get 'cancel'
    end

    collection do
      get 'history', to: 'requests#history'
    end
  end
  resources :profiles

  # Slack commandes
  post 'slack_commands/hero', to: 'slack_commands#hero'
  post 'slack_commands/my_requests', to: 'slack_commands#my_requests'

end

