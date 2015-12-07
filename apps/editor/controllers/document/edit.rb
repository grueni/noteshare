module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text
    expose :active_item

    def call(params)
      @active_item = 'editor'
      session[:current_document_id] = params[:id]
      puts "params[:id] = #{params[:id]}"
      puts "Editor, Document, Edit, session[:current_document_id] = #{session[:current_document_id]}".red
      # puts "Editor, session = #{session.inspect}".magenta if ENV[LOG_THIS]
      @document = DocumentRepository.find(session[:current_document_id])
      if @document.is_root_document?
        @document.compile_with_render
      else
        @document.update_content
      end
      # @document.update_content
      @updated_text = @document.content
    end

  end
end
