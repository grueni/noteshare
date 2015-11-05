module SessionManager::Controllers::User
  class Login
    include SessionManager::Action

    def call(params)
      puts ">> LOGIN USER".magenta

    end
  end
end
