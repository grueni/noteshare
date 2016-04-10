module Node::Controllers::Admin
  class List
    include Node::Action
    include Noteshare::Core

    expose :nodes, :active_item, :documents

    def call(paramm)
      @active_item = 'admin'
      @nodes = NSNodeRepository.public
      @documents = DocumentRepository.root_documents.select{ |document| document.title != nil }.sort_by{|document| document.title}
    end

  end
end
