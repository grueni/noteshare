module Web::Controllers::Home
  class Switchboard
    include Web::Action

    expose :active_it


    def call(params)

      puts 'controler = switchboard'.red

      @active_item = 'home'
      node = NSNode.from_http(request)

      if node
        cu = current_user(session)

        if cu == nil
          redirect_to "/node/#{node.id}"
        else
          if cu.id == node.owner_id
            redirect_to "/node/user/#{node.owner_id}"
          else
            redirect_to "/node/#{node.id}"
          end
        end
      else
        redirect_to '/home/'
      end

    end
  end
end
