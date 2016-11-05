module AccountsHelper
  def current_user
    Account.find(session[:user])
  end

  def logged_in?
    if !session[:user].nil?
      account = Account.find(session[:user])
      if session[:logged_in_at] > account.logged_out_at
        return true
      else
        return false
      end
    end
  end
end
