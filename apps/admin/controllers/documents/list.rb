module Admin::Controllers::Documents
  class List
    include Admin::Action

    expose :documents, :active_item

    def call(params)
      @active_item = 'admin'
      @documents = DocumentRepository.root_documents
    end
  end
end
