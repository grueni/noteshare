module Node::Controllers::Public
  class Show
    include Node::Action


    expose :node, :active_item

    def call(params)
       @active_item = ''
      puts "controller for Node: Public::Show".red

      @node = NSNodeRepository.find params[:id]

    end
  end
end
