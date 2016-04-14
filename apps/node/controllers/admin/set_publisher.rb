module Node::Controllers::Admin
  class SetPublisher
    include Node::Action

    def call(params)
      node = NSNode.find params[:id]
      node.make_all_documents_principal
      self.body = body_message('DONE!')
    end
  end
end
