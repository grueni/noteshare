# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Interface

    expose :document

    def call(params)

      doc_params = params[:document]
      puts "CCCC: doc_params = #{doc_params}"
      parent_id = doc_params['parent_id']
      title = doc_params['title']
      author = NSDocument::Interface::User.current
      puts "CCCC: author = #{author}"

      @document = DocumentRepository.create(NSDocument.new(title: title, author: author))
      @document.content ||= ''
      @document.update_content
      @document.compile_with_render

      if parent_id
        @parent_doc = DocumentRepository.find parent_id
        @document.add_to(@parent_doc)
        @parent_doc.update_table_of_contents
      end

      DocumentRepository.update @document

      redirect_to '/documents'
    end
  end
end