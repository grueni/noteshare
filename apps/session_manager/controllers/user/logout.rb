module SessionManager::Controllers::User
  class Logout
    include SessionManager::Action

    def call(params)
      session[:user_id] = nil
      self.body = "<div style='position:absolute;left:80px;top:80px;'>You are now logged out\n<br/><a href='/'>Back to Noteshare</a></div>"
    end
  end
end
