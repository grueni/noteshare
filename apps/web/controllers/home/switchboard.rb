
require_relative '../../../../lib/ui/links'

module Web::Controllers::Home
  class Switchboard
    include Web::Action
    include UI::Links

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

      @incoming_node = NSNode.from_http(request)

      if @incoming_node
        if  @incoming_node.type == 'public'
          redirect_to "/node/#{@incoming_node.id}"
        else
          redirect_to basic_link @incoming_node.name, "home"
        end
      else
        redirect_to '/home/'
      end

    end


    def call(params)

      puts "In Switchboard, Show, cookies[:current_node_id] = #{cookies[:current_node_id]}".red

      @active_item = 'home'
      handle_incoming_node

    end
  end
end
