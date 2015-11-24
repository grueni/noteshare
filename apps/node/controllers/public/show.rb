module Node::Controllers::Public
  class Show
    include Node::Action


    expose :node

    def call(params)

      puts "controller for Node: Public::Show".red

      @node = NSNodeRepository.find params[:id]

    end
  end
end
