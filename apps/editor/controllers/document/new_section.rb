module Editor::Controllers::Document
  class NewSection
    include Editor::Action

    expose :document
    expose :parent_document, :active_item, :create_mode

    def call(params)
      @active_item = 'editor'
      @create_mode = request.query_string
      puts 'controller: NewSection'.red
      puts "(1) query: #{request.query_string}".cyan
      @document = DocumentRepository.find params[:id]
      @parent_document = @document.parent_document

      puts "In controller, newSection, document = #{@document.title}"


    end

  end
end
