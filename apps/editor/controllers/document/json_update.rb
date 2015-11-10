module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    def call(params)
      puts "JSON update firing".red
      id = params['id'].to_i
      puts "ID = #{params['id']}".magenta
      # puts "jsonupdate, session = #{session.inspect}".magenta  if ENV[LOG_THIS]
      puts "------------------------------".blue
      #Fixme: is this the way to proceed?
      session[:current_document_id] = id
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      @document.update_content params['source']
      @document.synchronize_title
      self.body = @document.rendered_content
    end



    private
    def verify_csrf_token?
      false
    end


  end
end
