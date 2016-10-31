require 'twilio-ruby'
require 'securerandom'
class ProvidersController < ApplicationController
  def index
    if current_user == nil
      redirect_to root_url, :flash => { :errors => 'You must be logged in
        to view this resource' }
    end
    if current_user.public_key == ENV['PUBLIC_KEY']
      @title = "Providers"
      @providers = Provider.all
    else
      redirect_to account_path(current_user), :flash => { :errors => 'You are not a admin.' }
    end
  end

  def new
    @title = "Create Provider"
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)
    @provider.api_key = SecureRandom.hex(15)
    if @provider.save
      redirect_to provider_url(@provider)
    else
      redirect_to new_provider_url, :flash => { :errors => @provider.errors }
    end
  end

  def show
  end

  def login_form
    @provider = Provider.find_by(api_key: params[:api_key])
    @account = Account.find_by(public_key: params[:public_key])
    @title = 'Authorize ' + @provider.name

    if @account.is_broadcasted == false
      redirect_to providers_login_path, :flash => { :errors =>
        'You must first broadcast to confirm address ownership' }
    else
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
        provider.number_connected += 1
        provider.save
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
    @account.connections.find(params[:provider].to_i).destroy
    @account.save
    redirect_to account_path(@account), :flash => { :success => "Integration removed from account." }
  end

  private
  def provider_params
    params.require(:provider).permit(:name, :callback_url, :contact_email, :logo)
  end
end
