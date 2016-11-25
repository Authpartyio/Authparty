require 'rubygems'
require 'bitcoin-cigs'
require 'uri'
class Authparty::API < Grape::API
  version 'v1', using: :path
  format :json

  BASE_API_URL = ENV['BASE_API_URL']

  desc 'Authorize Scanned Interaction'
    post :authorize_login do
      address = params[:address].to_s
      signature = params[:generated_signature].to_s
      message = params[:generated_message].to_s
      if BitcoinCigs.verify_message(address, signature, message)
        @account = Account.find_or_create_from_wallet_address(params[:address])
        if @account.broadcast_code == nil
          charset = Array('A'..'Z') + Array('a'..'z')
          @account.broadcast_code = Array.new(15) { charset.sample }.join
        end
        if @account.save
          if @account.persisted?
            notice = 'User was logged in.'
          else
            notice = 'User was created.'
          end
          provider = Provider.find_by(api_key: params[:provider])
          provider_exists = false
          @account.connections.each do |c|
            if c.provider_id = provider.id
              provider_exists = true
            end
          end
          if provider_exists == false
            connection = @account.connections.new
            connection.provider_id = provider.id
            connection.connected_on = Time.now
            connection.bearer = SecureRandom.hex(32)
            provider.number_connected += 1
            provider.save
            connection.save
          end
          return :success => 'true'
        else
          # Placeholder for Websocket Errors Alert
          return :success => false, :errors => @account.errors
        end
      else
        # Placeholder for Websocket Cannot Confirm Authorization Alert
        return :success => false, :errors => 'We could not confirm your authorization.'
      end
    end

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
      get :authorize_qrcode do
        charset = Array('A'..'Z') + Array('a'..'z')
        generated_message = 'Authparty Login ' + Array.new(15) { charset.sample }.join
        provider = params[:api_key]
        callback = params[:callback_url]
        @value = url_encode("counterparty:?method=sign&message=" + URI.escape(generated_message.to_s) + "&provider=" + provider + "&callback=" + url_encode(callback))
        return "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=#{@value}"
      end
  end

end
