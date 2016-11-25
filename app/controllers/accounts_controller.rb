require 'httparty'
require 'json'
require 'uri'
require "erb"
include ERB::Util
class AccountsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :edit]
  def index
    @title = "All Accounts"
    @account = Account.all
  end

  def new
    @account = Account.new
    @title = "Login"
    @generated_message = 'Authparty Login ' + generate_code(15)
    @generated_signature = 'Authparty Login ' + generate_code(15)
    @modal_id = generate_code(15)
    if params[:redirect] != nil
      @callback = URI.escape(ENV['BASE_API_URL'] + '/api/v1/authorize_login?provider=' + params[:redirect] + '&modal_id=' + @modal_id)
      value = url_encode("counterparty:?action=sign&message=" + URI.escape(@generated_message.to_s) + "&callback=" + url_encode(@callback))
    else
      @callback = URI.escape(ENV['BASE_API_URL'] + '/api/v1/authorize_login?modal_id=' + @modal_id)
      value = url_encode("counterparty:?action=sign&message=" + URI.escape(@generated_message.to_s) + "&callback=" + url_encode(@callback))
    end
    @qr_data = value
  end

  def create
    if BitcoinCigs.verify_message(params[:account][:public_key],
      params[:account][:generated_signature], params[:account][:generated_message])
      @account = Account.find_or_create_from_wallet_address(params[:account][:public_key])
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
        if params[:account][:redirect] != nil
          redirect_to providers_login_url + '?api_key=' + params[:account][:redirect]
        else
          redirect_to account_path(@account), :flash => { :success => notice }
        end
      else
        redirect_to new_account_url, :flash => { :errors => @account.errors }
      end
    else
      redirect_to new_account_url, :flash => { :errors => 'We could not confirm your authorization.' }
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
    @account.update(public_key: params[:account][:public_key])
    redirect_to account_path(@account), :flash => { :success => 'Account updated.' }
  end

  def logout
    account = Account.find(session[:user])
    account.logged_out_at = Time.now
    account.save
    session.delete :user
    redirect_to root_url, :flash => { :success => 'User logged out.' }
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
