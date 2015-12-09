module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      id = session[:current_document_id]
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      @document.update_content params['source']
      @document.synchronize_title unless @document.dict_lookup('synchronize_title') == 'no'
      self.body = @document.rendered_content
=begin
      if @document.is_root_document?
        if @document.toc == []
          puts "making:endered_content (R)".magenta
          self.body = @document.rendered_content
        else
          puts "making:compiled_and_rendered_content".magenta
          self.body = @document.compiled_and_rendered_content
        end
      else
        puts "making:endered_content".red
        self.body = @document.rendered_content
      end
=end
    end



    private
    def verify_csrf_token?
      false
    end


  end
end
