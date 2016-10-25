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
      redirect_to @account
    else
      redirect_to account_url(@account.id)
    end
  end

  def show
    @title = "Account"
    @account = Account.find(params[:id])
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
