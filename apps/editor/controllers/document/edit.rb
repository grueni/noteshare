module Editor::Controllers::Document
  class Edit
    include Editor::Action

    expose :document
    expose :updated_text

    def call(params)
      session[:current_document_id] = params[:id]
      puts "params[:id] = #{params[:id]}"
      puts "Editor, Document, Edit, session[:current_document_id] = #{session[:current_document_id]}".red
      @document = DocumentRepository.find(session[:current_document_id])
      @document.update_content
      @updated_text = @document.content
    end

  end
end
