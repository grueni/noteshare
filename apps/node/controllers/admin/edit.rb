module Node::Controllers::Admin
  class Edit
    include Node::Action

    expose :active_item, :node

    def call(params)
      @active_item='admin'
      id = params['id']
      @node = NSNodeRepository.find(id)

    end

  end
end
