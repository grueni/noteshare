module Node::Controllers::Admin
  class New
    include Node::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
    end

  end
end
