module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text
    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, Edit')
      user = current_user(session)
      id = params['id']

      @active_item = 'editor'
      puts "ID of document to edit: #{id}".magenta
      @document = DocumentRepository.find(id)
      Analytics.record_edit(user, @document)
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
