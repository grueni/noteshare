module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    def call(params)

      user = current_user(session)

      puts "user: #{user.full_name}".red

      puts "controller: DeleteDocuments".red
      puts params[:id].red
      puts "CONTROL:".green
      puts params['document']['destroy']

      control =  params['document']['destroy']
      @document = DocumentRepository.find params[:id]

      if control == 'destroy'
        if Permission.new(user, :delete,  @document)
          DocumentRepository.delete @document
          node = user.node
          node.update_docs_for_owner
          message = "#{@document.title} has been deleted."
        else
          message= "Sorry, you do not have permission to delete this document."
        end
      else
        message = 'Cancelled'
      end

      message  <<  "  <br><a href='/node/user/#{current_user(session).id}'>Back to Noteshare</a>"

      self.body = message
    end
  end
end
