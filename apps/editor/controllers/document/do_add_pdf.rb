module Editor::Controllers::Document
  class DoAddPdf
    include Editor::Action

    def call(params)

      @document_id = params['document_id']
      @title = params['title']
      @tags = params['tags']
      @filename = params['datafile']['filename']
      @filename = 'test_' + @filename
      @type = params['datafile']['type']
      @tempfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      puts "tempfile: #{@tempfile}"

      puts params.raw.inspect.green
      puts params['document_id'].red

      @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )

      if @url
        raw_image = Image.new(title: @title, file_name: @filename, url: @url, tags: @tags, dict: {})
        @image = ImageRepository.create raw_image
        @message1 = "Image upload successful (id: #{@image.id})"
      end

      author = current_user2
      current_document = DocumentRepository.find @document_id
      puts "The current document with id #{current_document.id}".red

      if @type == 'application/pdf'
        content = "#{@url}[PDF document]\n\n"
        content << "++++\n"
        content << "<iframe src='#{@url}' width=100% height=1200 ></iframe>\n"
        content << "++++\n"
      else
        content =  "#{@url}[Image file]\n\n"
        content << "image::#{@url}[]"
      end

      new_document = NSDocument.create(title: @title, content: content, author_credentials: author.credentials)

      new_document.acl_set_permissions!('rw', '-', '-')
      new_document.dict['pdf:image_id'] = @image.id
      new_document.dict['pdf:url'] = @url

      ContentManager.new(new_document).update_content(nil)

      puts "I will save this document with id #{new_document.id}".red
      DocumentRepository.update new_document

      if current_document.is_root_document?
        create_mode = 'child'
      else
        create_mode = 'sibling_after'
      end

      case create_mode
        when 'child'
          new_document.add_to(current_document)
        when 'sibling_before'
          new_document.add_as_sibling_of current_document, :before
        when 'sibling_after'
          new_document.add_as_sibling_of current_document, :after
        else
          puts 'do nothing'
      end

      Analytics.record_new_pdf_document(author, new_document)

      redirect_to "/editor/document/#{new_document.id}"

    end

    #Fixme: this is BAAAD!!
    private
    def verify_csrf_token?
      false
    end


  end
end
