class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  include AccountsHelper

  protected
  def authenticate_user!
    if session[:user] != nil
      
    else
      redirect_to root_path, :flash => { :errors => 'You must be authenticated to view that resource.' }
    end
  end
end
