module Node::Controllers::User
  class Show
    include Node::Action

    # puts request.env["rack.session.unpacked_cookie_data"].to_s.red

    expose :current_node, :presenter
    expose :current_document, :active_item


    def call(params)

      puts "HOLA!!!".red

      puts "params[:id] = #{params[:id]}".red


      @active_item = 'node'

      # get current user node

      @current_node = current_user2.node
      if @current_node == nil
        redirect_to '/error:0?Sorry, your node could not be found'
      end

      @presenter = Noteshare::Presenter::Node::NodePresenter.new(@current_node, current_user2)

      # get current document
      if session[:current_document_id]
        @current_document = DocumentRepository.find session[:current_document_id]
      end

    end

  end
end
