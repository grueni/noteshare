module Editor::Controllers::Document
  class CreateNewAssociatedDocument
    include Editor::Action

    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, CreateNewAssociatedDocument')
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

      current_document = DocumentRepository.find current_document_id
      puts "current_document: #{current_document.title} (#{current_document_id})"
      author_id = current_document.author_credentials2['id']
      puts "author_id: #{author_id}".red
      author = UserRepository.find author_id
      puts "In create_new_section, current_document: #{current_document_id} (#{current_document.title})".red
      puts "--- Author is #{author.screen_name}".red
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)
      # new_document.acl_set_permissions('rw', 'r', '-')
      new_document.acl = current_document.root_document.acl
      new_document.update_content(nil)
      DocumentRepository.update new_document
      new_document.associate_to(current_document, type)

      redirect_to "/editor/document/#{current_document.root_document.id}"

    end

  end
end
