module Editor::Controllers::Document
  class EditToc
    include Editor::Action

    expose :document, :outer_table_of_contents, :active_item

    def call(params)
      @active_item = 'editor'
      @document = DocumentRepository.find params['id']
      parent = @document.parent_document
      @document = parent if parent
      @outer_table_of_contents = OuterTableOfContents.new(@document, [], {})

      session['current_document_id'] = @document.id
      puts "current_document_id = #{session['current_document_id']}".red

    end


    #Fixme: we really shouldn't do this
    private
    def verify_csrf_token?
      false
    end


  end
end
