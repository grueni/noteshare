module Editor::Controllers::Document
  class AddPdf
    include Editor::Action

    expose :document, :parent_document, :create_mode
    expose :active_item


    def call(params)
      @active_item = 'editor'
      @create_mode = request.query_string
      @document = DocumentRepository.find params[:id]
      @parent_document = @document.parent_document
    end
  end
end
