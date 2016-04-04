module Editor::Controllers::Document
  class EditHeader
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      id = params[:id]
      @document = DocumentRepository.find id
    end

  end
end
