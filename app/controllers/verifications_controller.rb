require 'json'
class VerificationsController < ApplicationController
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
