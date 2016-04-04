module Editor::Controllers::Document
  class Options
    include Editor::Action

     expose :document, :active_item, :mode

    def call(params)
      @active_item = 'editor'
      query_string = request.query_string
      @document = DocumentRepository.find params[:id]
      if query_string == 'root'
        @document = @document.root_document if query_string == 'root'
        @mode = 'root'
      else
        @mode = 'section'
      end
    end

  end
end
