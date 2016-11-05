module AccountsHelper
  def current_user
    Account.find(session[:user])
  end

  def logged_in
    if session[:user] != nil
      account = Account.find(session[:user])
      if account.logged_out_at != nil
        if session[:logged_in_at] < account.logged_out_at
          return false
        else
          return true
        end
      else
        return true;
      end
    else
      return false;
    end
  end
end
