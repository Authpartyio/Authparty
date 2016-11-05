require 'httparty'
require 'json'
class AccountsController < ApplicationController

  def index
    @title = "All Accounts"
    @account = Account.all
  end

  def new
    @title = "Create Account"
    @account = Account.new
  end

  def create
    p request.env['omniauth.auth']
    @account = Account.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if @account.broadcast_code == nil
      @account.broadcast_code = generate_code(15)
    end
    if @account.save
      if @account.persisted?
        notice = 'User was logged in.'
      else
        notice = 'User was created.'
      end
      session[:user] = @account.id
      session[:logged_in_at] = Time.now
      redirect_to account_path(@account), :flash => { :success => notice }
    else
      redirect_to new_account_url, :flash => { :errors => @account.errors }
    end
  end

  def show
    @title = "Account"
    @account = Account.find(current_user)

    if @account.is_broadcasted == false
      @response = 'Valid broadcast not found on the blockchain.'
    else
      @response = 'Valid broadcast found and confirmed.'
    end

    @providers = []
    @account.connections.each do |c|
      @providers << Provider.find(c.provider_id)
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    @account.update(account_params(public_key: params[:public_key]))
    redirect_to account_path(@account), :flash => { :success => 'Account updated.' }
  end

  def logout
    token = params[:logout_token]
    data = {
      body: {
        logout_token: token,
        app_id: ENV['APP_ID'],
        app_secret: ENV['APP_SECRET']
      }
    }
    url = 'https://clef.io/api/v1/logout'
    response = HTTParty.post(url, data)
    if response.success?
      clef_id = response['clef_id']
      account = Account.find_by(clef_id: clef_id)
      account.logged_out_at = Time.now
      account.save
    else
      p response.response
    end
  end

  def generate_code(number)
    charset = Array('A'..'Z') + Array('a'..'z')
    Array.new(number) { charset.sample }.join
  end

  protected
  def check_user
    @user = Account.find(session[:user])
    redirect_to root_path if @user = nil
  end

  private
  def account_params
    params.require(:account).permit(:public_key, :broadcast_code, :clef_id)
  end
end
