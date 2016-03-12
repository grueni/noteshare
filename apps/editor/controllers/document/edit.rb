module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document, :updated_text, :current_image,:active_item, :editors

    def call(params)
      redirect_if_not_signed_in('editor, document, Edit')
      user = current_user(session)
      id = params['id']
      user.dict2['current_document_id'] = id
      UserRepository.update user
      session['current_document_id'] = id
      puts "EDITOR IS RECORDING CURRENT DOCUMENT ID AS #{id}".magenta

      if session['current_image_id']
        puts "session['current_image_id'] = #{session['current_image_id']}".red
        @current_image = ImageRepository.find session['current_image_id']
        puts "VERIFY: #{@current_image.id}".cyan if @current_image
      end

      @active_item = 'editor'
      @document = DocumentRepository.find(id)
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
