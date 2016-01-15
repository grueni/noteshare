module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes, :active_item

    def call(paramm)
      @active_item = 'admin'
      puts "call: controller Node, Admin, List".red
      @nodes = NSNodeRepository.all.sort_by{|node| node.name}
    end

  end
end
