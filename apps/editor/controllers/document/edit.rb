module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text
    expose :active_item
    expose :document_being_edited_id

    def call(params)
      @active_item = 'editor'
      puts "I will edit document #{params[:id]}".magenta
      @document_being_edited_id =  params[:id]
      session[:current_document_id] = params[:id]
      puts "in EDIT, session[:current_document_id] = #{session[:current_document_id]}".magenta
      @document = DocumentRepository.find(session[:current_document_id])
      if @document.is_root_document?
        @document.compile_with_render
      else
        @document.update_content
      end
      @updated_text = @document.content
    end

  end
end
