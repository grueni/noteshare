module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text
    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, Edit')
      @active_item = 'editor'
      # id = request.env['REQUEST_URI'].split('/')[-1].sub(/\#.*$/, '')
      id = params['id']
      puts "ID of document to edit: #{id}".magenta
      @document = DocumentRepository.find(id)
      session[:current_document_id] = id
      if @document.is_root_document?
        @document.compile_with_render_lazily
      else
        @document.update_content_lazily
      end
      @updated_text = @document.content
    end

  end
end
