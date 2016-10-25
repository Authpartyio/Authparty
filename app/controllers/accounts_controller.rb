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
    if @account.save
      redirect_to @account
    else
      redirect_to '/send_sms?id=' + @account.id
    end
  end

  def show
    @title = "Account"
    @account = Account.find(params[:id])
  end

  private
  def account_params
    params.require(:account).permit(:public_key, :mobile_number)
  end
end
