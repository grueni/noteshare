module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document, :root_document, :updated_text, :current_image,:active_item, :editors

    def call(params)
      id = params['id']
      @document = DocumentRepository.find(id)
      @root_document = @document.root_document

      # Do not edit document root in the regular editor
      if @document.is_root_document?
        @document = @document.first_section
        id = @document.id
      end


      current_user2.dict2['current_document_id'] = id
      UserRepository.update current_user2
      session['current_document_id'] = id

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end

      @active_item = 'editor'

      Analytics.record_edit(current_user2, @document)


      cm = ContentManager.new(@document)
      if @document.is_root_document?
        cm.compile_with_render_lazily
      else
        cm.update_content_lazily
      end
      @updated_text = @document.content

      es = Noteshare::EditorStatus.new(@document)
      @editors = "Editors: #{es.editor_array_string_value}"
      es.add_editor(current_user2)

      if ['compiled', 'titlepage'].include? current_user2.dict2['reader_view']
        current_user2.dict2['reader_view'] = 'sidebar'
        UserRepository.update current_user2
      end


    end

  end
end
