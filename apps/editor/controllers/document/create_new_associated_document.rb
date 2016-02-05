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

      current_document = DocumentRepository.find current_document_id

      author = UserRepository.find current_document.author_id
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)

      #Fixme: the following is to be deleted when author_id is retired
      author_id = current_document.author_credentials2['id']
      new_document.author_id = author_id.to_i

      new_document.acl = current_document.root_document.acl

      ContentManager.new(new_document).update_content(nil)

      DocumentRepository.update new_document
      AssociateDocManager.new(new_document).associate_to(current_document, type)

      redirect_to "/editor/document/#{current_document.root_document.id}"

    end

  end
end
