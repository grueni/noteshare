# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Interface
    include NSDocument::Asciidoc

    expose :document

    def call(params)

      doc_params = params[:document]
      parent_id = doc_params['parent_id']
      title = doc_params['title']
      author = current_user_full_name

      @document = DocumentRepository.create(NSDocument.new(title: title, author: author))

      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render

      if parent_id != ''
        @parent_doc = DocumentRepository.find parent_id.to_i
        @document.add_to(@parent_doc)
        @parent_doc.update_table_of_contents
      end

      DocumentRepository.update @document

      redirect_to "/document/#{@document.id}"
    end
  end
end