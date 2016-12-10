require 'securerandom'
require 'json'
class ProvidersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :edit]
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
    @provider.api_secret = SecureRandom.hex(30)
    if @provider.save
      redirect_to provider_url(@provider)
    else
      redirect_to new_provider_url, :flash => { :errors => @provider.errors }
    end
  end

  def show
    @title = "Provider Information"
    @provider = Provider.find(params[:id])
    @authorizations = Connection.where(provider_id: @provider.id).all
    @tokens = @provider.tokens.all
    if @authorizations.count > 0
      @auth_count = 0
      @authorizations.each do |a|
        @auth_count = @auth_count + 1
      end
      @auth_msg = 'Authorization found: ' + @auth_count.to_s
    else
      @auth_msg = 'No authorizations found'
    end
  end

  def update
  end

  def login_form
    @provider = Provider.find_by(api_key: params[:api_key])
    if logged_in == true && @provider != nil
      @account = Account.find(current_user)
      if params[:token] != nil
        if @account.is_broadcasted == false
          redirect_to root_url, :flash => { :errors =>
            'You must first broadcast to confirm address ownership' }
        end
      else
        @title = 'Authorize ' + @provider.name
        render :layout => false
      end
    else
      redirect_to new_account_url + '?redirect=' + @provider.api_key
    end
  end

  def authenticate
    @account = Account.find(current_user)
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
    redirect_to provider.callback_url + '?success=true&address=' + @account.public_key
  end

  def revoke
    @account = Account.find(params[:account])
    @account.connections.find_by(provider_id: params[:provider].to_i).destroy
    @account.save
    redirect_to account_path(@account), :flash => { :success => "Integration removed from account." }
  end

  private
  def provider_params
    params.require(:provider).permit(:name, :callback_url, :contact_email, :logo)
  end
end
