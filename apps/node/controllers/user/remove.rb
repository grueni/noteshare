module Node::Controllers::User
  class Remove
    include Node::Action

    def call(params)
      node = NSNodeRepository.find current_user2.node.id
      document_id = params['id']
      puts node.name.red
      document = DocumentRepository.find document_id
      if document && node
        node.remove_doc(document_id)
      else
        redirect_to "/error/5?Either the node or the document was invalid"
      end
      redirect_to "/node/manage/#{node.id}"
    end
  end
end
