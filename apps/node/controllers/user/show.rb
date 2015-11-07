module Node::Controllers::User
  class Show
    include Node::Action


    expose :current_node
    expose :documents
    expose :current_document

    def call(params)
      puts "Node, User, Show: ".red
      puts "params[:id] = #{params[:id]}".cyan
      @current_node = NSNodeRepository.find params[:id]
      puts "Node name = #{@current_node.name}".blue

      if session[:current_doc_id]
        @current_document = DocumentRepository.find session[:current_doc_id]
      end

      @documents  = self.documents

    end

  end
end
