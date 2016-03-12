module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document, :updated_text, :current_image,:active_item, :editors

    def call(params)
      redirect_if_not_signed_in('editor, document, Edit')
      user = current_user(session)
      id = params['id']
      @document = DocumentRepository.find(id)

      # Do not edit document root in the regular editor
      if @document.is_root_document?
        @document = @document.first_section
        id = @document.id
      end


      user.dict2['current_document_id'] = id
      UserRepository.update user
      session['current_document_id'] = id

      if session['current_image_id']
        @current_image = ImageRepository.find session['current_image_id']
      end

      @active_item = 'editor'

      Analytics.record_edit(user, @document)


      cm = ContentManager.new(@document)
      if @document.is_root_document?
        cm.compile_with_render_lazily
      else
        cm.update_content_lazily
      end
      @updated_text = @document.content

      es = Noteshare::EditorStatus.new(@document)
      @editors = "Editors: #{es.editor_array_string_value}"
      es.add_editor(user)

      if ['compiled', 'titlepage'].include? user.dict2['reader_view']
        user.dict2['reader_view'] = 'sidebar'
        UserRepository.update user
      end


    end

  end
end
