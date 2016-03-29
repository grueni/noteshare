require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
require_relative '../../../../lib/noteshare/modules/subdomain'
require 'keen'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action
    include Noteshare::Subdomain
    include Keen

    expose :user

    def handle_login
      if @user
        params[:user]['authenticated']  = true
      else
        params[:user]['authenticated']  = false
        redirect_to basic_link @user.node_name, 'home'
      end
    end

    def handle_redirect

      if ENV['MODE'] == 'LOCAL'
        redirect_to "/node/#{@user.node_id}"
      else
        redirect_to basic_link(@user.node_name, "node/start")
      end


    end

    def call(params)
      puts "app = session_manager, controller = authenticate".red
      puts session.inspect.cyan

      session[:user_id] = nil
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      @user = authenticator.login(session)

      Keen.publish(:sign_ins, { :username => @user.screen_name }) if @user && !@user.admin

      if @user == nil
        redirect_to '/error/0?Error signing in — please check your password and login email'
      end
      puts "Loged in user (#{@user.id}) is #{@user.full_name}".red
      puts "User's node is #{@user.node.id}".red

      # handle_login
      handle_redirect

    end


  end
end
