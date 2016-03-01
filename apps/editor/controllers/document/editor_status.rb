module Editor::Controllers::Document
  class EditorStatus
    include Editor::Action

    def call(params)
      redirect_if_not_signed_in('editor, document, CreateNewAssociatedDocument')
      query_string = request.query_string
      @document = DocumentRepository.find params['id']
      puts "Setting status of #{@document.title} (#{@document.id}) to 'OK'"

      es = Noteshare::EditorStatus.new(@document)
      if query_string == 'clear'
        es.clear_editors
      else
        es.remove_editor(current_user(session))
      end


      redirect_to "/document/#{@document.id}"
    end
  end
end
