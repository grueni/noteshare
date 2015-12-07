module SessionManager::Controllers::User
  class Login
    include SessionManager::Action

    def call(params)
      puts "controller SessionManager, Login".magenta

    end
  end
end
