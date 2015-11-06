require_relative '../../../../lib/user_authentication'

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    # https://discuss.lotusrb.org/t/problem-after-updating-to-0-4-0/99
    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      result = authenticator.login(session)
      params[:user]['authenticated']  = result
    end


  end
end
