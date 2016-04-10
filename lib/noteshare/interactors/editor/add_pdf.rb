require 'lotus/interactor'

module Noteshare
  module Document
    module Interactor
      class AddPDF

        include Lotus::Interactor
        expose :new_document, :author

        def initialize(params, author)
          @params = params
          @author = author
          @document_id = @params['document_id']
          @title = @params['title']
          @tags = @params['tags']
          @filename = @params['datafile']['filename']
          @filename = 'test_' + @filename
          @type = @params['datafile']['type']
          @current_document = DocumentRepository.find @document_id
        end

        def upload_file
          @tempfile = @params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]
          @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )
        end

        def enter_file_in_database
          if @url
            raw_image = Image.new(title: @title, file_name: @filename, url: @url, tags: @tags, dict: {})
            @image = ImageRepository.create raw_image
            @message1 = "Image upload successful (id: #{@image.id})"
          end
        end

        def prepare_content_for_document
          if @type == 'application/pdf'
            @content = "#{@url}[PDF document]\n\n"
            @content << "++++\n"
            @content << "<iframe src='#{@url}' width=100% height=1200 ></iframe>\n"
            @content << "++++\n"
          else
            @content =  "#{@url}[Image file]\n\n"
            @content << "image::#{@url}[]"
          end
        end

        def add_content_to_document
          @new_document = NSDocument.create(title: @title, content: @content, author_credentials: @author.credentials)
          @new_document.acl_set_permissions!('rw', '-', '-')
          @new_document.dict['pdf:image_id'] = @image.id
          @new_document.dict['pdf:url'] = @url

          ContentManager.new(@new_document).update_content(nil)
          DocumentRepository.update @new_document
        end

        def attach_document

          @parent_document = @current_document.parent_document
          document_manager = DocumentManager.new(@parent_document)

          if @current_document.is_root_document?
            @create_mode = 'child'
          else
            @create_mode = 'sibling_after'
          end

          case @create_mode
            when 'child'
              document_manager.append(@new_document)
            when 'sibling_before'
              document_manager.add_as_sibling(new_sibling: @new_document, direction: :before, old_sibling: @current_document)
            when 'sibling_after'
              document_manager.add_as_sibling(new_sibling: @new_document, direction: :after, old_sibling: @current_document)
            else
              puts 'do nothing'
          end
        end

        def call
          upload_file
          enter_file_in_database
          prepare_content_for_document
          add_content_to_document
          attach_document
        end


      end
    end
  end
end

