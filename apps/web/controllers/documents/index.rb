 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents, :nodes
    expose :active_item

    def call(params)

      # @documents = DocumentRepository.root_documents.sort_by { |item| item.title }
      @documents = DocumentRepository.root_documents
      @active_item = 'documents'


      @nodes = NSNodeRepository.all
    end


  end
end
