require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      session[:user_id] = nil
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      user = authenticator.login(session)
      if user
        puts "user authenticated: #{user.full_name}".red
      else
        puts "Error: could note authenticate".red
      end
      params[:user]['authenticated']  = (user != nil)
      redirect_to  "/node/user/#{user.id}"
    end


  end
end
