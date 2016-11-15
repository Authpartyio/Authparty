require 'json'
class ApiController < ApplicationController
  respond_to do |format|
    format.html { render :layout => false } # your-action.html.erb
  end

  API_INFO = {
    :name => 'Authparty API',
    :version => '0.0.0'
  }

  def index
    render :json => API_INFO.to_json
  end

end
