module Node::Controllers::Admin
  class EditSidebar
    include Node::Action

    expose :active_item, :node

    def call(params)
      puts "Edit sidebar call".red
      if current_user2
        puts "  -- current_user: #{current_user2.full_name}".cyan
      else
        puts "  -- no add_column :, :, :".cyan
      end
      redirect_if_not_signed_in('image, Admin,  Edit')
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
