module SessionManager::Controllers::User
  class Logout
    include SessionManager::Action

    def call(params)
      session[:user_id] = nil
      self.body = 'You are now logged out'
    end
  end
end
