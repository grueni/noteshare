module Node::Controllers::User
  class Show
    include Node::Action


    expose :current_node
    expose :documents
    expose :current_document

    # Go to the node belonging to the user
    def call(params)

      user_id = params[:id]
      @current_node = NSNodeRepository.for_owner_id user_id
      if @current_node == nil
        @message = "Sorry, your node could not be found."
        puts @message.red
        redirect_to '/'
      end
      if session[:current_document_id]
        @current_document = DocumentRepository.find session[:current_document_id]
      end
      @documents  = self.documents

    end

  end
end
