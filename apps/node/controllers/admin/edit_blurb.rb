module Node::Controllers::Admin
  class EditBlurb
    include Node::Action

    expose :active_item, :node

    def call(params)
      @active_item='admin'
      id = params['id']
      @node = NSNode.find(id)
      #fixme:
      if @node.meta == nil
        @node.meta = {}
        @node.update
      end
    end
  end
end
