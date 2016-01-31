module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document, :updated_text, :current_image,:active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, Edit')
      user = current_user(session)
      id = params['id']

      if session['current_image_id']
        puts "session['current_image_id'] = #{session['current_image_id']}".red
        @current_image = ImageRepository.find session['current_image_id']
        puts "VERIFY: #{@current_image.id}".cyan if @current_image
      end

      @active_item = 'editor'
      puts "ID of document to edit: #{id}".magenta
      @document = DocumentRepository.find(id)
      Analytics.record_edit(user, @document)
      session[:current_document_id] = id

      cm = ContentManager.new(@document)
      if @document.is_root_document?
        cm.compile_with_render_lazily
      else
        cm.update_content_lazily
      end
      @updated_text = @document.content
    end

  end
end
