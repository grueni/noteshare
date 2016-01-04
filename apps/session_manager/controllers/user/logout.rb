module SessionManager::Controllers::User
  class Logout
    include SessionManager::Action

    def call(params)
      user = UserRepository.find session[:user_id]
      logout(user, session)
      self.body = "<div style='position:absolute;left:80px;top:80px;'>You are now logged out\n<br/><a href='http://#{ENV['HOME']}'>Back to #{ENV['NAME']}</a></div>"
    end
  end
end
