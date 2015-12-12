require_relative '../../../../lib/user_authentication'
require_relative  '../../../../lib/noteshare/repositories/user_repository'
# include UserRepository

module SessionManager::Controllers::User
  class Authenticate
    include SessionManager::Action

    expose :user

    def handle_incoming_node
      @incoming_node = NSNode.from_http(request)

      if @incoming_node
        puts "Incoming node: #{@incoming_node.name} (id: #{@incoming_node.id}, owner_id: #{@incoming_node.owner_id})".red
      else
        puts "No incoming nodo".red
        redirect_to '/home/' if @incoming_node == nil
      end

    end

    def handle_current_user
      @cu = current_user(session)

      if @cu
        @user_node = NSNodeRepository.for_owner_id cu.id
        puts "Current user: #{@cu.full_name}".red
        puts "current user id: #{@cu.id}"
      else
        puts "No current user".red
        redirect_to "/node/#{@incoming_node.id}"  if @cu == nil
      end

    end

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


      incoming_node = NSNode.from_http(request)
      user_node = NSNodeRepository.for_owner_id user.id

      if incoming_node
        puts "User node: #{user_node.name}".red
      end


      # session['domain'] = '.localhost'
      puts "at end of 'authenticate', session = #{session.inspect}".cyan
      redirect_to  "/node/user/#{user.id}"
    end


  end
end
