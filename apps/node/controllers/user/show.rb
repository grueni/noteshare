module Node::Controllers::User
  class Show
    include Node::Action


    expose :current_node
    expose :documents

    def call(params)
      puts "Node, User, Show: ".red
      puts "params[:id] = #{params[:id]}".cyan
      @current_node = NSNodeRepository.find params[:id]
      puts "Node name = #{@current_node.name}".blue

      @documents  = self.documents

    end

  end
end
