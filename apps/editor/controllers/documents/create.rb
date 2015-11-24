# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Interface
    include NSDocument::Asciidoc

    expose :document

    def call(params)
      puts "controller create!!!".red
      doc_params = params[:document]
      title = doc_params['title']
      author_credentials = current_user(session).credentials


      @document = NSDocument.create(title: title, author_credentials: author_credentials)
      @document.author = current_user(session).full_name

      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render


      DocumentRepository.update @document

      redirect_to "/document/#{@document.id}"
    end

  end
end