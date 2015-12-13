require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    def handle_login
      puts "Enter handle_login".red
      if @user
        params[:user]['authenticated']  = true
        puts "user authenticated: #{@user.full_name}".red
        puts "at end of 'authenticate', session = #{session.inspect}".cyan
      else
        params[:user]['authenticated']  = false
        puts "Error: could not authenticate".red
        redirect_to '/home'
      end
    end

    def handle_redirect

      puts "Enter handle redirect".red
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

      puts "SessionManager, AUTHENTICATE".magenta
      puts "at beginning of 'authenticate', session = #{session.inspect}".cyan
      puts "ENV['DOMAIN'] = #{ENV['DOMAIN']}".red

      session[:user_id] = nil
      authenticator = UserAuthentication.new(params[:user]['email'], params[:user]['password'])
      @user = authenticator.login(session)

      handle_login
      handle_redirect

    end


  end
end
