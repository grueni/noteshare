module Node::Controllers::Public
  class List
    include Node::Action

    expose :nodes, :active_item

    def call(paramm)
      @active_item = 'admin'
      puts "call: controller Node, Public, List".red
      @nodes = NSNode.all
    end

  end
end
