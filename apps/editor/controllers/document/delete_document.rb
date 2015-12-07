module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    def call(params)

      user = current_user(session)
      control =  params['document']['destroy']
      @document = DocumentRepository.find params[:id]

      if control == 'destroy'
        if Permission.new(user, :delete,  @document)
          message = "#{@document.title} has been deleted."
          @document.delete
          node = user.node
          node.update_docs_for_owner
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
