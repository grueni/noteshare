module Web::Controllers::Home
  class Switchboard
    include Web::Action

    expose :active_it

    def handle_incoming_node
      @incoming_node = NSNode.from_http(request)

      if @incoming_node
        puts "Incoming node: #{@incoming_node.name} (id: #{@incoming_node.id}, owner_id: #{@incoming_node.owner_id})".red
        puts "Redirect to node".cyan
        redirect_to "/node/#{@incoming_node.id}"  if @cu == nil
      else
        puts "No incoming nodo".red
        puts "Redirect to home".cyan
        redirect_to '/home/'
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

      puts 'controller = switchboard'.red

      @active_item = 'home'

      handle_incoming_node

    end
  end
end
