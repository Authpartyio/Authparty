require 'twilio-ruby'
require 'securerandom'
class ProvidersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def login_form
    @provider = Provider.find_by(api_key: params[:api_key])
    @account = Account.find_by(public_key: params[:public_key])
    @title = 'Authorize ' + @provider.name

    @account.verification_code = 1_000_000 + rand(10_000_000 - 1_000_000)
    @account.save

    to = @account.mobile_number
    if to[0] = "0"
      to.sub!("0", '+1')
    end

    @twilio_client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio_client.account.sms.messages.create(
      :from => ENV['TWILIO_PHONE_NUMBER'],
      :to => to,
      :body => "A login request to #{@provider.name} has been made.\n\n Your verification code is #{@account.verification_code}."
    )

    render :layout => false
  end

  def authenticate
    @account = Account.find_by(public_key: params[:public_key])
    if @account.verification_code == params[:verification_code]
      @account.is_verified = true
      @account.verification_code = ''
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
        connection.save
      end
      #if @account.providers_authorized.include?(provider.id)
        #@account.providers_authorized << provider.id
      #else
      #  @account.providers_authorized << provider.id
      #end
      #log_in(@account)
      redirect_to provider.callback_url + '?success=true&address=' + @account.public_key
    end
  end

  def revoke
    @account = Account.find(params[:account])
    @account.providers_authorized.delete(params[:provider].to_i)
    @account.save
    redirect_to account_path(@account), :flash => { :success => "Integration removed from account." }
  end
end
