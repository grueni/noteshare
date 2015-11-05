module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      email = params[:user]['email']
      password = params[:user]['password']
      authenticated = UserRepository.authenticate(email, password)
      params[:user]['authenticated'] = authenticated
      puts "authenticated: #{params[:user]['authenticated']}".cyan
    end
  end
end
