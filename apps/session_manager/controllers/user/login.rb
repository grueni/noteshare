module SessionManager::Controllers::User
  class Login
    include SessionManager::Action

    def call(params)
      puts "controller SessionManager, Login".magenta
      puts "session = #{session.inspect}".cyan
      puts "ENV['DOMAIN'] = #{ENV['DOMAIN']}".red

    end
  end
end
