module Node::Controllers::Admin
  class SetPublisher
    include Node::Action

    def call(params)
      redirect_if_not_admin('node, Admin,  SetPublisher')
      node = NSNodeRepository.find params[:id]
      node.make_all_documents_principal
      self.body = body_message('DONE!')
    end
  end
end
