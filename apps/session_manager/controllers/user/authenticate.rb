module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      email = params[:user]['email']
      password = params[:user]['password']
      user = UserRepository.find_one_by_email(email)
      if user
        authenticated = user.authenticate(password)
        params[:user]['authenticated'] = authenticated
        puts "authenticated: #{params[:user]['authenticated']}".cyan
        user.login(password)
      else
        params[:user]['authenticated'] = false
      end

    end
  end
end
