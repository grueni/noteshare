module Editor::Controllers::Document
  class DeleteDocument
    include Editor::Action

    def call(params)

      puts "controller; DeleteDocument".magenta

      user = current_user(session)

      puts "In DeleteDocument, current_user = #{user.full_name}".cyan



      control =  params['document']['destroy']
      puts "control = #{control}".cyan

      @document = DocumentRepository.find params[:id]

      if control == 'destroy'
        if Permission.new(user, :delete,  @document)
          message = "#{@document.title} has been deleted."
          puts message.cyan
          @document.delete
          puts "A: doc deleted".cyan
          node = user.node
          puts "B: get node".cyan
          node.update_docs_for_owner
          puts "C: node.update_docs_for_owner".cyan
        else
          message= "Sorry, you do not have permission to delete this document."
        end
      else
        message = 'Cancelled'
      end

      message  <<  "  <br><a href='/node/user/#{current_user(session).id}'>Back to Noteshare</a>"
      puts "FINAL MESSAGE:  #{message}".cyan

      self.body = message
    end
  end
end
