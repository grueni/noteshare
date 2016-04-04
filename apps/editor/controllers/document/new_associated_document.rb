module Editor::Controllers::Document
  class NewAssociatedDocument
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      @document = DocumentRepository.find params['id']
      if @document == nil
        redirect_to "/error/#{params['id']}?No document found (weird)!"
      end
    end

  end
end
