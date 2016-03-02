module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action

    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, document, CreateNewSection')
      @active_item = 'editor'
      puts 'controller: CreateNewSection'.red
      puts "(2) query: #{request.query_string}".cyan
      # puts params.inspect.red


      document_packet = params['document']
      puts document_packet.inspect.red

      title = document_packet['title']
      if title == nil or title == ''
        redirect_to '/error/:0?Please enter a title for the new section'
      end
      content = document_packet['content']
      parent_id = document_packet['parent_id']
      create_mode = document_packet['create_mode'] || 'sibling_below'

      current_document_id = document_packet['current_document_id']

      user = current_user(session)

      puts "user: #{user.screen_name}".magenta
      puts "parent_id: #{parent_id}".magenta
      puts "create_mode: #{create_mode  }".magenta

      current_document = DocumentRepository.find current_document_id
      if current_document.is_root_document?
        create_mode = 'child'
      end


      _author_credentials = current_document.author_credentials2
      author = UserRepository.find _author_credentials['id']

      puts "In create_new_section, current_document: #{current_document_id} (#{current_document.title})".red
      puts "--- Author is #{author.screen_name}".red
      new_document = NSDocument.create(title: title, content: content, author_credentials: _author_credentials)
      #Fixme: the following is to be deleted when author_id is retired
      new_document.author_id = _author_credentials['id'].to_i
      new_document.acl = current_document.root_document.acl
      # new_document.acl_set_permissions!('rw', '-', '-')


      ContentManager.new(new_document).update_content(nil)

      DocumentRepository.update new_document

      Analytics.record_new_section(user, new_document)

      case create_mode
        when 'child'
          new_document.add_to(current_document)
        when 'sibling_above'
          new_document.add_as_sibling_of current_document, :before
        when 'sibling_below'
          new_document.add_as_sibling_of current_document, :after
        else
          puts 'do nothing'
      end
      redirect_to "/editor/document/#{new_document.id}"


    end
  end
end
