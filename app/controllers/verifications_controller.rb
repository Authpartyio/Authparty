require 'twilio-ruby'
require 'counterparty_ruby'
require 'json'
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

  def confirm_broadcast
    @title = 'Verifify Broadcast'
    @account = Account.find(params[:id])
    address = @account.public_key
    @response = JSON.parse(HTTParty.get('https://counterpartychain.io/api/broadcasts/' + address))
    @broadcasts = @response['data']

    if 0 == @response['total'].to_i
      @result = @account.public_key + ' has never made a broadcast.'
    else
      @broadcasts.each do |b|
        if b['text'] == "AUTHPARTY VERIFY-ADDRESS " + @account.broadcast_code
          @result = 'Found matching broadcast!'
          @account.is_broadcasted = true
          @account.save
          break
        else
          @result = 'No valid broadcast found.'
        end
      end
    end
  end
end
