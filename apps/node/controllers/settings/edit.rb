module Node::Controllers::Settings
  class Edit
    include Node::Action
    expose :active_item

    def call(params)
      @active_item = 'node'
    end
  end
end
