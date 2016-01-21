module Editor::Controllers::Document
  class Options
    include Editor::Action

     expose :document, :active_item, :mode

    def call(params)
      redirect_if_not_signed_in('editor, document, Options')
      @active_item = 'editor'
      puts "controller Editor Options".red
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
