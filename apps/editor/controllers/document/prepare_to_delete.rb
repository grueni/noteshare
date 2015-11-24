module Editor::Controllers::Document
  class PrepareToDelete
    include Editor::Action

    expose :document

    def call(params)
      @document = DocumentRepository.find params[:id]
    end
  end
end
