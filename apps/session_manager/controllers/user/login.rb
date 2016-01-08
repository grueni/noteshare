module SessionManager::Controllers::User
  class Login
    include SessionManager::Action

    def call(params)
      puts "app = session_manager, controller = login".red
      puts "session = #{session.inspect}".cyan
      puts "ENV['DOMAIN'] = #{ENV['DOMAIN']}".red

    end
  end
end
