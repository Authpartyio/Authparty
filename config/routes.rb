Rails.application.routes.draw do
  get 'connections/index'

  get 'connections/new'

  get 'connections/create'

  get 'connections/show'

  get 'connections/destroy'

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

  resources :providers
  get 'providers_login'            => 'providers#login_form'
  patch 'providers_authenticate'   => 'providers#authenticate'
  get 'providers_revoke'           => 'providers#revoke'

  resources :accounts
end
