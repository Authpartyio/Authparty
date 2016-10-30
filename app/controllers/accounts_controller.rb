require 'json'
require 'logger'
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
    @account = Account.new(account_params)
    @account.broadcast_code = generate_code(15)
    if @account.save
      session[:current_user] = @account.id
      log_in(@account)
      redirect_to account_url(@account)
    else
      redirect_to new_account_url, :flash => { :errors => @account.errors }
    end
  end

  def show
    if current_user == nil
      redirect_to root_url, :flash => { :errors => 'You must be logged in
        to view this resource' }
    end
    @title = "Account"
    @account = Account.find(current_user)

    if @account.is_broadcasted == false
      @response = 'Valid broadcast not found on the blockchain.'
    else
      @response = 'Valid broadcast found and confirmed.'
    end
  end

  def generate_code(number)
    charset = Array('A'..'Z') + Array('a'..'z')
    Array.new(number) { charset.sample }.join
  end

  private
  def account_params
    params.require(:account).permit(:public_key, :mobile_number, :broadcast_code)
  end
end
