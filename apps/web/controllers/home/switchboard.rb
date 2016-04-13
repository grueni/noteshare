
require_relative '../../../../lib/ui/links'

module Web::Controllers::Home


  class Switchboard
    include Web::Action
    include UI::Links
    include Noteshare::Core::Node

    expose :active_item


    def host_base
      http_host_parts = request.env['HTTP_HOST'].split('.')
      if http_host_parts[-1] =~ /localhost/
        return http_host_parts[-1]
      else
        return "#{http_host_parts[-2]}.#{http_host_parts[-1]}"
      end
    end


    # There are currently two values for the value of @node.type:
    # 'public' and 'personal'
    def handle_incoming_node

      puts "handle_incoming_node".red

      referer = request.env["HTTP_REFERER"]
      puts "referer: #{referer}".cyan
      @incoming_node = NSNode.from_http(request)
      @incoming_node_name =  @incoming_node.name if @incoming_node
      if @incoming_node
        puts "@incoming_node: #{@incoming_node.name}".red
      else
        puts "No incoming node".red
      end

      if current_user2
        prefix = current_user2.screen_name
      else
        prefix = @incoming_node_name || :none
      end

      if @incoming_node
        if  @incoming_node.type == 'public'
          # redirect_to "/node/#{@incoming_node.id}"
          puts 'A'.magenta
          redirect_to basic_link prefix, "node/#{@incoming_node.id}"
        else
          puts 'B'.magenta
          redirect_to basic_link @incoming_node.name, "home"
        end
      else
        puts 'C'.magenta
        # redirect_to '/home/'
        redirect_to basic_link :none, 'home'
      end

    end


    def call(params)
      @active_item = 'home'
      handle_incoming_node

    end
  end
end
