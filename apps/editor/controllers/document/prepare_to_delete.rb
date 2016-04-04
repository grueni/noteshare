module Editor::Controllers::Document
  class PrepareToDelete
    include Editor::Action

    expose :document, :active_item, :delete_mode

    def call(params)
      @delete_mode = request.query_string
      @active_item = 'editor'
      @document = DocumentRepository.find params[:id]
    end
  end
end
