module Node::Controllers::Admin
  class List
    include Node::Action

    expose :nodes, :active_item, :documents

    def call(paramm)
      @active_item = 'admin'
      @nodes = NSNodeRepository.public
      @documents = DocumentRepository.root_documents.sort_by{|document| document.title}
    end

  end
end
