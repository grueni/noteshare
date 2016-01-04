module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      # id = session[:current_document_id]
      puts "PARAMS".red
      puts params.inspect.cyan
      puts
      puts "REQUEST_URI:".magenta
      puts request.env['REQUEST_URI'].magenta

      request_uri = request.env['REQUEST_URI']
      id  = request_uri.split('/')[-1]

      # id = params[:document][:document_id]
      puts "in json_update, id = #{id}".magenta
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      @document.update_content params['source']
      @document.synchronize_title unless @document.dict['synchronize_title'] == 'no'
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


    #Fixme: this is BAAAD!!
    private
    def verify_csrf_token?
      false
    end


  end
end
