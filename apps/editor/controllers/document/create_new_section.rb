module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action

    def call(params)
      puts 'controller: CreateNewSection'.red

      document_packet = params['document']
      title = document_packet['title']
      content = document_packet['content']
      parent_id = document_packet['parent_id']

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "parent_id: #{parent_id}".magenta

      author = UserRepository.find user.id
      current_document = DocumentRepository.find session[:current_document_id]
      # current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)

      new_document.add_to(current_document)

      redirect_to "/document/#{new_document.id}"

    end
  end
end
