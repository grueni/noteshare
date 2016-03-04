module Node::Controllers::Admin
  class EditSidebar
    include Node::Action

    expose :active_item, :node

    def call(params)

      def call(params)
        puts "Edit sidebar call".red
        cu = current_user(session)
        if cu
          puts "  -- current_user: #{cu.full_name}".cyan
        else
          puts "  -- no current_user".cyan
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
end
