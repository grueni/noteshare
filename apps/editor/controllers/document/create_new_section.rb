module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action

    def call(params)
      puts 'controller: CreateNewSection'.red

      document_packet = params['document']
      title = document_packet['title']
      options = document_packet['options']
      content = document_packet['content']
      parent_id = document_packet['parent_id']

      if options
        option_hash = options.hash_value || {}
      end

      associated_doc_type = option_hash['associate_as'] || ''
      author = UserRepository.find current_user(session).id

      current_document = DocumentRepository.find session[:current_document_id]
      current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)


      if associated_doc_type == ''
        new_document.add_to(current_root_document)
      else
        new_document.associate_to(current_document, associated_doc_type,)
      end

      redirect_to "/document/#{new_document.id}"

    end
  end
end
