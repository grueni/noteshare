module Editor::Controllers::Document
  class CreateNewAssociatedDocument
    include Editor::Action

    def call(params)
      puts 'controller: CreateNewAssociatedDocument'.red

      document_packet = params['document']
      title = document_packet['title']
      options = document_packet['options']
      content = document_packet['content']
      parent_id = document_packet['parent_id']

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta

      puts "options: #{options}".magenta
      puts "parent_id: #{parent_id}".magenta

      if options
        option_hash = options.hash_value || {}
        puts "option_hash: #{option_hash}".magenta
      else
        option_hash = {}
      end

      associated_doc_type = option_hash['associate_as'] || ''
      author = UserRepository.find user.id

      current_document = DocumentRepository.find session[:current_document_id]
      current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)

      puts "associated_doc_type: #{associated_doc_type}".red

      if associated_doc_type == ''
        new_document.add_to(current_root_document)
      else
        new_document.associate_to(current_document, associated_doc_type,)
      end

      node = NSNodeRepository.find user.node_id
      if node
        node.update_docs_for_owner
      else
        puts "No node for user #{user.screen_name}".magenta
      end


      redirect_to "/document/#{new_document.id}"

    end

  end
end
