module Node::Controllers::User
  class Show
    include Node::Action

    # puts 'controller NODE, USER, SHOW'.red
    # puts request.env["rack.session.unpacked_cookie_data"].to_s.red

    expose :current_node
    expose :documents
    expose :current_document, :active_item

    # Go to the node belonging to the user
    def call(params)
      @active_item = 'node'
      user_id = params[:id]
      # @current_node = NSNodeRepository.for_owner_id user_id
      @current_node = NSNodeRepository.find user.node_id
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
