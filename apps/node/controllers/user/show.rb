module Node::Controllers::User
  class Show
    include Node::Action

    # puts request.env["rack.session.unpacked_cookie_data"].to_s.red

    expose :current_node, :presenter
    expose :current_document, :active_item


    def call(params)
      redirect_if_not_signed_in('image, User,  Show')
      @active_item = 'node'

      # get current user node
      @user = current_user(session)
      @current_node = current_user(session).node
      if @current_node == nil
        redirect_to '/error:0?Sorry, your node could not be found'
      end

      @presenter = NodePresenter.new(@current_node, @user)

      # get current document
      if session[:current_document_id]
        @current_document = DocumentRepository.find session[:current_document_id]
      end

    end

  end
end
