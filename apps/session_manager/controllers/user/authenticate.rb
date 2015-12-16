require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    def handle_login
      if @user
        params[:user]['authenticated']  = true
      else
        params[:user]['authenticated']  = false
        redirect_to '/home'
      end
    end

    def handle_redirect

      @user_node = NSNodeRepository.for_owner_id @user.id
      @user_node_name = @user_node.name

      if ENV['DOMAIN'] == nil
        session[:domain]  = '.login'
        redirect_to "http://#{@user_node_name}.localhost:2300/node/user/#{@user.id}"
        # redirect_to "/node/user/#{@user.id}"
      else
        redirect_to "http://#{@user_node_name}#{ENV['DOMAIN']}/node/user/#{@user.id}"
      end

    end

    def call(params)

      session[:user_id] = nil
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      @user = authenticator.login(session)

      handle_login
      handle_redirect

    end


  end
end
