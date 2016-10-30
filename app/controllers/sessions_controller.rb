require 'twilio-ruby'
class SessionsController < ApplicationController
  def new
  end

  def create
    @account = Account.find_by(public_key: params[:session][:public_key])
    if @account == nil
      redirect_to login_url, :flash => { :errors => "Address unknown." }
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
        :body => "A login request to AUTHPARTY has been made.\n\n Your verification code is #{@account.verification_code}."
      )
      redirect_to '/verify_login?id=' + @account.id.to_s, :flash => { :success => "A verification code has been sent to your mobile. Please fill it in below." }
    end
  end

  def confirm_code
    @title = "Enter Confirmation Code"
  end

  def confirm_accepted
    @account = Account.find(params[:id])
    if @account.verification_code == params[:verification_code]
      @account.is_verified = true
      @account.verification_code = ''
      @account.save
      log_in(@account)
      redirect_to account_url(@account.id), :flash => { :success => "Thank you for loging in." }
      return
    end
  else
    redirect_to login_url, :flash => { :errors => "Invalid verification code." }
  end

  def destroy
    log_out
  end
end
