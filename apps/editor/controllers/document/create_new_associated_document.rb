module Editor::Controllers::Document
  class CreateNewAssociatedDocument
    include Editor::Action

    expose :active_item

    def call(params)
      @active_item = 'editor'
      puts 'controller: CreateNewAssociatedDocument'.red

      document_packet = params['document']
      title = document_packet['title']
      type = document_packet['type'] || 'note'
      content = document_packet['content']
      parent_id = document_packet['parent_id']

      type = 'note' if type == ''

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "type: #{type}".magenta
      puts "parent_id: #{parent_id}".magenta

      author = UserRepository.find user.id

      current_document = DocumentRepository.find session[:current_document_id]
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)
      new_document.acl_set_permissions('rw', 'r', '-')
      DocumentRepository.update new_document
      new_document.associate_to(current_document, type)


      redirect_to "/document/#{new_document.id}"

    end

  end
end
