module Editor::Controllers::Document
  class EditorStatus
    include Editor::Action

    def call(params)
      redirect_if_not_signed_in('editor, document, CreateNewAssociatedDocument')
      @document = DocumentRepository.find params['id']
      puts "Setting status of #{@document.title} (#{@document.id}) to 'OK'"

      es = Noteshare::EditorStatus.new(@document)
      es.remove_editor(current_user(session))

      redirect_to "/document/#{@document.id}"
    end
  end
end
