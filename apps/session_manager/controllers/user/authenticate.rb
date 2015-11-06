require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
include UserRespository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action


    expose :user

    # https://discuss.lotusrb.org/t/problem-after-updating-to-0-4-0/99
    def call(params)
      puts "SessionManager, AUTHENTICATE".magenta
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      login_succeeded = authenticator.login(session)
      params[:user]['authenticated']  = login_succeeded
      if login_succeeded
        user = UserRespository.find_by_email(params[:user]['email'])
        user_node_id = user.node_id
        if user_node_id
          redirect_to "node/user/#{node_id}"
        end
      end
    end


  end
end
