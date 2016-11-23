require 'rubygems'
require 'bitcoin-cigs'
require 'uri'
class Authparty::API < Grape::API
  version 'v1', using: :path
  format :json

  BASE_API_URL = ENV['BASE_API_URL']

  desc 'Authorize Scanned Interaction'
    post :authorize_login do
      address = CGI.unescape(params[:address])
      signature = params[:generated_signature]
      message = CGI.unescape(params[:generated_message])
      puts address
      puts signature
      puts message
      #address = '11o51X3ciSjoLWFN3sbg3yzCM8RSuD2q9'
      #signature = 'HIBYi2g3yFimzD/YSD9j+PYwtsdCuHR2xwIQ6n0AN6RPUVDGttgOmlnsiwx90ZSjmaWrH1/HwrINJbaP7eMA6V4='
      #message = 'this is a message'
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
          provider = Provider.find_by(api_key: params[:api_key])
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
  end

  def generate_code(number)
    charset = Array('A'..'Z') + Array('a'..'z')
    Array.new(number) { charset.sample }.join
  end

end
