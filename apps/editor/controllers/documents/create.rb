# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Asciidoc

    def get_format(author)
      author_format = author.dict2['format']
      if author_format
        format_hash = {format: author_format}
      else
        format_hash = {format: 'adoc-latex'}
      end
      format_hash
    end

    expose :document

    def call(params)
      redirect_if_not_signed_in('editor, documents, Create')
      puts "controller create!!!".red
      doc_params = params[:document]
      title = doc_params['title']
      _author = current_user(session)
      _author_credentials = _author.credentials

      @document = NSDocument.create(title: title, author_credentials: _author_credentials)
      @document.author = _author.full_name
      @document.render_options = get_format(_author)


      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render


      @document.acl_set_permissions!('rw', 'r', '-')

      user = current_user(session)
      user_node = user.node
      if user_node
        user_node.add_document_by_id(@document.id)
        NSNodeRepository.update user_node
      end

      redirect_to "/document/#{@document.id}"
    end

  end
end