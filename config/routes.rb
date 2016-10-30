Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  root 'welcome#index'

  get 'send_sms'  => 'verifications#create'
  get 'verify'    => 'verifications#confirm_code'
  patch 'verify'  => 'verifications#confirm_accepted'

  get 'broadcast' => 'verifications#confirm_broadcast'

  get 'login'            => 'sessions#new'
  post 'login'           => 'sessions#create'
  get 'verify_login'     => 'sessions#confirm_code'
  patch 'verify_login'   => 'sessions#confirm_accepted'
  get 'logout'           => 'sessions#destroy'

  resources :accounts
end
