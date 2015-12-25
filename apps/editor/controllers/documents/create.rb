# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Asciidoc

    def get_format(author)
      author_format = author.dict['format']
      if author_format
        format_hash = {format: author_format}
      else
        format_hash = {format: 'adoc-latex'}
      end
      format_hash
    end

    expose :document

    def call(params)
      puts "controller create!!!".red
      doc_params = params[:document]
      title = doc_params['title']
      _author = current_user(session)
      author_credentials = _author.credentials

      @document = NSDocument.create(title: title, author_credentials: author_credentials)
      @document.author = _author.full_name
      @document.render_options = get_format(_author)


      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render


      DocumentRepository.update @document

      user = current_user(session)
      node = NSNodeRepository.find user.node_id
      if node
        node.update_docs_for_owner
      else
        puts "No node for user #{user.screen_name}".magenta
      end

      redirect_to "/document/#{@document.id}"
    end

  end
end