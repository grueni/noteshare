module Editor::Controllers::Document
  class NewSection
    include Editor::Action

    expose :document
    expose :parent_document

    def call(params)

      @document = DocumentRepository.find params[:id]
      @parent_document = @document.parent_document


    end

  end
end
