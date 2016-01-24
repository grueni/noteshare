module Node::Controllers::User
  class Remove
    include Node::Action

    def call(params)
      redirect_to "/error/5?Either the node or the document was invalid" if current_user(session) == nil
      puts params['id'].red
      puts current_user(session).screen_name.red
      node = NSNodeRepository.find current_user(session).node.id
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
