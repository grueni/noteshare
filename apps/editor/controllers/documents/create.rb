# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Interface
    include NSDocument::Asciidoc

    expose :document

    def call(params)
      puts "controller create".red
      doc_params = params[:document]
      parent_id = doc_params['parent_id']
      title = doc_params['title']
      author_credentials = current_user(session).credentials

      begin
        option = doc_params['options'].hash_value
      rescue
        option = {}
      end
      associated_doc_type = option['associate_as'] || ''

      puts "DOC_PARAMS['options']: #{doc_params['options']}"

      @document = NSDocument.create(title: title, author_credentials: author_credentials)
      @document.author = current_user(session).full_name

      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render

      if parent_id != ''
        @parent_doc = DocumentRepository.find parent_id.to_i
        if associated_doc_type == ''
          @document.add_to(@parent_doc)
        else
          @document.associate_to(@parent_doc, associated_doc_type,)
        end
      end

      DocumentRepository.update @document

      redirect_to "/document/#{@document.id}"
    end

  end
end