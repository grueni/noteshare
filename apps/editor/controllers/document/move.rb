module Editor::Controllers::Document
  class Move
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      doc_id =  params[:id]
      @document = DocumentRepository.find doc_id
      new_parent = @document.move_leve_up
      redirect_to "/editor/document/#{new_parent.id}"
    end

  end
end
