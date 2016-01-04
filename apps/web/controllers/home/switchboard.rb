module Web::Controllers::Home
  class Switchboard
    include Web::Action

    expose :active_it


    def host_base
      http_host_parts = request.env['HTTP_HOST'].split('.')
      if http_host_parts[-1] =~ /localhost/
        return http_host_parts[-1]
      else
        return "#{http_host_parts[-1]}.#{http_host_parts[-2]}"
      end
    end


    # There are currently two values for the value of @node.type:
    # 'public' and 'personal'
    def handle_incoming_node
      puts "handle_incoming_node".red
      @incoming_node = NSNode.from_http(request)
      puts "after @incoming_node"
      puts "@incoming_node: #{@incoming_node.inspect}"

      if @incoming_node
        # redirect_to "/node/#{@incoming_node.id}"  if @cu == nil or @incoming_node.type == 'public'
        redirect_to "/node/#{@incoming_node.id}"  if  @incoming_node.type == 'public'
      else
        puts "redirect_to '/home/'".red
        redirect_to '/home/'
      end

    end

    def handle_current_user
      @cu = current_user(session)

      if @cu
        @user_node = NSNodeRepository.for_owner_id cu.id
      else
        redirect_to "/node/#{@incoming_node.id}"  if @cu == nil
      end

    end


    def call(params)

      puts "host: #{host_base}".red

      @active_item = 'home'

      handle_incoming_node

      puts "after handle_incoming_node".red

    end
  end
end
