module Editor::Controllers::Document
  class EditToc
    include Editor::Action

    expose :document, :outer_table_of_contents, :active_item

    def call(params)

      @active_item = 'editor'

      puts "PARAMS:".red
      puts params.inspect.cyan

      @document = DocumentRepository.find params['id']
      @outer_table_of_contents = OuterTableOfContents.new(@document, [], {})

    end
  end
end
