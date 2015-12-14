module Editor::Controllers::Document
  class EditToc
    include Editor::Action

    expose :document, :outer_table_of_contents, :active_item

    def call(params)

      @active_item = 'editor'

      @document = DocumentRepository.find params['id']
      @outer_table_of_contents = OuterTableOfContents.new(@document, [], {})

    end


    #Fixme: we really shouldn't do this
    private
    def verify_csrf_token?
      false
    end


  end
end
