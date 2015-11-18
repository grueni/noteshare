module Node::Controllers::User
  class Show
    include Node::Action


    expose :current_node
    expose :documents
    expose :current_document

    def call(params)
      puts "Node, User, Show: ".red
      puts "params[:id] = #{params[:id]}".cyan
      user_id = params[:id]
      @current_node = NSNodeRepository.for_owner_id user_id


      puts "Node name = #{@current_node.name}".blue

      if session[:current_document_id]
        @current_document = DocumentRepository.find session[:current_document_id]
      end

      @documents  = self.documents

      puts "EXIT: node show controller".magenta

    end

  end
end
