require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
require_relative '../../../../lib/noteshare/modules/subdomain'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action
    include Noteshare::Subdomain

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

      @user_node = NSNodeRepository.for_owner_id @user.id
      # @user_node_name = @user_node.name
      redirect_to basic_link(@user.node_name, "node/#{@user.node_id}")

    end

    def call(params)
      puts "app = session_manager, controller = authenticate".red
      puts session.inspect.cyan

      session[:user_id] = nil
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      @user = authenticator.login(session)

      # handle_login
      handle_redirect

    end

    #Fixme: this is BAAAD!!
    private
    def verify_csrf_token?
      false
    end


  end
end
