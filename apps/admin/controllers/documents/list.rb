require_relative '../../../../lib/noteshare/interactors/advanced_searcher'

module Admin::Controllers::Documents
  class List
    include Admin::Action

    expose :documents, :active_item

    def call(params)
      redirect_if_not_admin('Attempt to list courses (admin, documents, list)')
      @active_item = 'admin'
      @documents = DocumentRepository.root_documents.sort_by { |document| document.title }
    end
  end
end
