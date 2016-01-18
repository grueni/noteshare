module Editor::Controllers::Document
  class NewAssociatedDocument
    include Editor::Action

    expose :document
    expose :parent_document , :active_item

    def call(params)
      @active_item = 'editor'
      puts 'controller: NewAssociatedDocument'.red
      @document = DocumentRepository.find params['id']
      @parent_document = @document.parent_document

      puts "In controller, newSection, document = #{document.title}"
    end

  end
end
