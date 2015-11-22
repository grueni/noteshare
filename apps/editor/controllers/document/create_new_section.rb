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

      puts "title: #{title}".red
      puts "options: #{options}".red
      puts "content: #{content}".red
      puts "parent_id: #{parent_id}".red

      puts "current_user id: #{current_user(session).id}".magenta

      author = UserRepository.find current_user(session).id

      current_document = DocumentRepository.find session[:current_document_id]
      current_root_document = current_document.root_document
      new_document = NSDocument.create(title: title, content: content, author_credentials: author.credentials)
      new_document.add_to(current_root_document)

      redirect_to "/document/#{new_document.id}"

=begin
      parent_id = doc_params['parent_id']
      title = doc_params['title']
      author_credentials = current_user(session).credentials

      begin
        option = doc_params['options'].hash_value
      rescue
        option = {}
      end
      associated_doc_type = option['associate_as'] || ''

      puts "DOC_PARAMS['options']: #{doc_params['options']}"

      @document = DocumentRepository.create(NSDocument.new(title: title, author_credentials: author_credentials))
      @document.author = current_user(session).full_name

      @document.content = prepare_content(@document, doc_params['content'])
      @document.update_content
      @document.compile_with_render

      if parent_id != ''
        @parent_doc = DocumentRepository.find parent_id.to_i
        if associated_doc_type == ''
          @document.add_to(@parent_doc)
        else
          @document.associate_to(@parent_doc, associated_doc_type,)
        end
      end

      DocumentRepository.update @document

      redirect_to "/document/#{@document.id}"
=end
    end
  end
end
