module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    def call(params)
      id = session[:current_document_id]
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      @document.update_content params['source']
      @document.synchronize_title unless @document.dict_lookup('synchronize_title') == 'no'
      if @document.is_root_document?
        self.body = @document.compiled_and_rendered_content
      else
        self.body = @document.rendered_content
      end
    end



    private
    def verify_csrf_token?
      false
    end


  end
end
