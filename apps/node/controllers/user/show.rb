module Node::Controllers::User
  class Show
    include Node::Action

    # puts 'controller NODE, USER, SHOW'.red
    # puts request.env["rack.session.unpacked_cookie_data"].to_s.red

    expose :current_node, :presenter
    expose :current_document, :active_item


    def call(params)
      redirect_if_not_signed_in('image, User,  Show')
      @active_item = 'node'

      # get current user node
      @user = UserRepository.find  params[:id]
      @current_node = current_user(session).node
      if @current_node == nil
        @message = "Sorry, your node could not be found."
        puts @message.red
        redirect_to '/'
      end

      @presenter = NodePresenter.new(@current_node, @user)

      # get current document
      if session[:current_document_id]
        @current_document = DocumentRepository.find session[:current_document_id]
      end


      # @documents = self.documents

    end

  end
end
