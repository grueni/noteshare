module Web::Controllers::Home
  class Switchboard
    include Web::Action

    expose :active_it

    def handle_incoming_node
      @incoming_node = NSNode.from_http(request)

      if @incoming_node
        redirect_to "/node/#{@incoming_node.id}"  if @cu == nil
      else
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

      @active_item = 'home'

      handle_incoming_node

    end
  end
end
