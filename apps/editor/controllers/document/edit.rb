module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text
    expose :active_item

    def call(params)
      @active_item = 'editor'
      puts "I will edit document #{params[:id]}".magenta
      id = request.env['REQUEST_URI'].split('/')[-1].sub(/\#.*$/, '')
      puts "ID of document to edit: #{id}".magenta
      session[:current_document_id] = params['id']
      @document = DocumentRepository.find(session[:current_document_id])
      if @document.is_root_document?
        @document.compile_with_render_lazily
      else
        @document.update_content_lazily
      end
      @updated_text = @document.content
    end

  end
end
