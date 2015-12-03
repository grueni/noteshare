module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes

    def call(paramm)
      puts "call: controller Node, Admin, List".red
      @nodes = NSNodeRepository.all

    end
  end
end
