module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  # Returns the current logged-in user (if any).
  def current_user
    Account.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_url, :flash => { :success => "You have been logged out." }
  end
end
