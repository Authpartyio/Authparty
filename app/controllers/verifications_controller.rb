require 'twilio-ruby'
class VerificationsController < ApplicationController
  def create
    @account = Account.find(params[:id])
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
      :body => "Your verification code is #{@account.verification_code}."
    )
    redirect_to '/verify?id=' + @account.id.to_s, :flash => { :success => "A verification code has been sent to your mobile. Please fill it in below." }
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
      redirect_to account_url(@account.id), :flash => { :success => "Thank you for verifying your mobile number." }
      return
    end
  else
    redirect_to account_url(@account.id), :flash => { :errors => "Invalid verification code." }
  end
end
