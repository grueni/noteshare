module Node::Controllers::Admin
  class EditSidebar
    include Node::Action

    expose :active_item, :node

    def call(params)
      redirect_if_not_signed_in('image, Admin,  Edit')
      @active_item='admin'
      id = params['id']
      @node = NSNode.find(id)
      #fixme:
      if @node.meta == nil
        @node.meta = {}
        NSNode.update @node
      end

    end
  end
end
