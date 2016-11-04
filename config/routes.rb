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

  resources :accounts do
    collection do
      match 'logout', to: 'accounts#logout', via: [:get, :post]
    end
  end

  get 'login' => 'accounts#new'
  match '/auth/:provider/callback', to: 'accounts#create', via: [:get, :post]

  resources :providers
  get 'providers_login'            => 'providers#login_form'
  get 'providers_authenticate'   => 'providers#authenticate'
  get 'providers_revoke'           => 'providers#revoke'
end
