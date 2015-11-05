module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    # https://discuss.lotusrb.org/t/problem-after-updating-to-0-4-0/99
    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      user = UserRepository.find_one_by_email(params[:user]['email'])
      result = false
      if user
        password = params[:user]['password']
        result = user.login(password, session)
        puts "Login result = #{result}".red
      end
      params[:user]['authenticated'] = result
    end


  end
end
