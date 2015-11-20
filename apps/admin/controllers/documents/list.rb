module Admin::Controllers::Documents
  class List
    include Admin::Action

    expose :documents

    def call(params)
      @documents = DocumentRepository.root_documents
    end
  end
end
