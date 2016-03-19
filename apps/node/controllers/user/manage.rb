module Node::Controllers::User
  class Manage
    include Node::Action

    expose :active_item, :documents, :current_node

    def call(params)
      @active_item = 'document'
      id = params['id']
      @current_node = NSNodeRepository.find id
      redirect_to "/error/3?Node #{id} not found" if @current_node == nil
      @documents = @current_node.documents_readable_by(current_user2)
    end
  end

end
