module Node::Controllers::Admin
  class EditBlurb
    include Node::Action

    expose :active_item, :node

    def call(params)
      puts "Edit blurb call".red
      if current_user2
        puts "  -- current_user: #{current_user2.full_name}".cyan
      else
        puts "  -- no current_user".cyan
      end
      @active_item='admin'
      id = params['id']
      @node = NSNodeRepository.find(id)
      #fixme:

      if @node.meta == nil
        @node.meta = {}
        NSNodeRepository.update @node
      end

    end
  end
end
