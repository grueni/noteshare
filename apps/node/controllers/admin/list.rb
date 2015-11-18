module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes

    def call(paramm)

      @nodes = NSNodeRepository.all

    end
  end
end
