module AccountsHelper
  def current_user
    Account.find_by(id: session[:user])
  end

  def logged_in?
    !current_user.nil?
  end
end
