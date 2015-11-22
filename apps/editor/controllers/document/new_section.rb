module Editor::Controllers::Document
  class NewSection
    include Editor::Action

    expose :document
    expose :parent_document

    def call(params)
      puts 'controller: NewSection'.red
      @document = DocumentRepository.find params[:id]
      @parent_document = @document.parent_document

      puts "In controller, newSection, document = #{document.title}"


    end

  end
end
