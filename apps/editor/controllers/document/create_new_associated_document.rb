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
      current_document_id = document_packet['current_document_id']

      type = 'note' if type == ''

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "type: #{type}".magenta

      author = UserRepository.find user.id

      current_document = DocumentRepository.find current_document_id
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)
      new_document.acl_set_permissions('rw', 'r', '-')
      DocumentRepository.update new_document
      new_document.associate_to(current_document, type)

      redirect_to "/editor/document/#{current_document.root_document.id}"

    end

  end
end
