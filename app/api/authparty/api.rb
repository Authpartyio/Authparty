class Authparty::API < Grape::API
  version 'v1', using: :path
  format :json

  BASE_API_URL = ENV['BASE_API_URL']

  resource :providers do
    desc 'Return Provider Information'
      get :/ do
        providers = []
        Provider.all.each do |p|
          providers << {
            name: p.name,
            email: p.contact_email,
            logo: p.logo
          }
        end
        return providers
      end
      get :find do
        Provider.find_by(api_key: params[:api_key])
      end
      get :authorize_url do
        return BASE_API_URL + 'providers_login?api_key=' + params['api_key']
      end
  end

end
