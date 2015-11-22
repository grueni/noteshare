module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    def call(params)

      puts "delete doc with id:".red
      puts params[:id].red
      @document = DocumentRepository.find params[:id]
      if Permission.new(current_user(session), :delete,  @document)
        DocumentRepository.delete @document
        message = "#{@document.title} has been deleted."
      else
        message= "Sorry, you do not have permission to delete this document."
      end

      message  <<  "  <br><a href='/node/user/#{current_user(session).id}'>Back to Noteshare</a>"

      self.body = message
      self.body = message
    end
  end
end
